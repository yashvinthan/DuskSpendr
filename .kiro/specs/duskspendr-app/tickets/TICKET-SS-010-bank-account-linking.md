# SS-010: Bank Account Linking via OAuth 2.0

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-010 |
| **Epic** | Account Linking System |
| **Type** | Feature |
| **Priority** | P0 - Critical |
| **Story Points** | 13 |
| **Sprint** | Sprint 2-3 |
| **Assignee** | TBD |
| **Labels** | `account-linking`, `oauth`, `security`, `banking`, `api` |

---

## User Story

**As a** DuskSpendr user  
**I want** to securely link my bank accounts  
**So that** my transactions are automatically imported and I don't need to manually enter expenses

---

## Description

Implement secure bank account linking using OAuth 2.0 authentication flow with Account Aggregator (AA) framework or Open Banking APIs. Users will authenticate directly with their bank through a secure WebView, and DuskSpendr will receive read-only access to transaction data. This follows the Zerodha model of account linking where user credentials never pass through DuskSpendr servers.

---

## Acceptance Criteria

### AC1: Bank Selection
```gherkin
Given I am on the account linking screen
When I view available banks
Then I should see a list of supported banks:
  | Bank | Logo | Status |
  | SBI | ✓ | Available |
  | HDFC | ✓ | Available |
  | ICICI | ✓ | Available |
  | Axis | ✓ | Available |
  | Kotak | ✓ | Coming Soon |
And each bank should show its official logo
And I can search/filter banks by name
```

### AC2: OAuth Flow Initiation
```gherkin
Given I select a bank (e.g., SBI)
When I tap "Link Account"
Then the app should:
  - Display a consent screen explaining data access
  - Open the bank's authentication in a secure WebView
  - Show clear indication this is the bank's official page
And my banking credentials should never be entered in DuskSpendr UI
```

### AC3: Successful Linking
```gherkin
Given I complete bank authentication successfully
When the OAuth callback is received
Then the app should:
  - Store the access/refresh tokens securely
  - Display success confirmation with account details (last 4 digits)
  - Trigger initial transaction sync
  - Return to account management screen
And the linked account should appear in my accounts list
```

### AC4: Failed Linking
```gherkin
Given the OAuth flow fails (user cancels, timeout, bank error)
When the error is detected
Then the app should:
  - Display appropriate error message
  - Provide "Try Again" option
  - Not store any partial credentials
  - Log the error for debugging (without sensitive data)
```

### AC5: Token Management
```gherkin
Given a linked account with OAuth tokens
When the access token expires
Then the app should:
  - Automatically refresh using the refresh token
  - If refresh fails, notify user to re-authenticate
  - Mark account as "needs attention" in UI
And transaction sync should resume after re-authentication
```

### AC6: Account Unlinking
```gherkin
Given I have a linked bank account
When I choose to unlink it
Then the app should:
  - Request confirmation with warning about data
  - Revoke OAuth tokens at the bank
  - Delete stored tokens locally
  - Optionally delete or keep historical transactions
  - Remove account from linked accounts list
```

---

## Technical Requirements

### Architecture Flow

```
┌──────────────┐     ┌─────────────────┐     ┌───────────────┐
│  DuskSpendr  │────▶│   AA Gateway    │────▶│   Bank API    │
│    App       │◀────│   (Backend)     │◀────│   (OAuth)     │
└──────────────┘     └─────────────────┘     └───────────────┘
       │                     │
       ▼                     ▼
┌──────────────┐     ┌─────────────────┐
│  Local DB    │     │   Redis/Cache   │
│  (Encrypted) │     │   (Tokens)      │
└──────────────┘     └─────────────────┘
```

### Flutter Implementation

```dart
// lib/features/accounts/domain/usecases/link_bank_account.dart
class LinkBankAccountUseCase {
  final AccountRepository _repository;
  final OAuthService _oauthService;
  
  Future<Result<LinkedAccount>> execute(Bank bank) async {
    try {
      // 1. Get OAuth authorization URL from backend
      final authUrl = await _repository.getAuthorizationUrl(bank.id);
      
      // 2. Open bank's auth page in secure WebView
      final authResult = await _oauthService.authenticate(
        url: authUrl,
        callbackScheme: 'DuskSpendr',
        bank: bank,
      );
      
      if (authResult.isCancelled) {
        return Result.failure(UserCancelledException());
      }
      
      // 3. Exchange authorization code for tokens (via backend)
      final tokens = await _repository.exchangeCodeForTokens(
        bankId: bank.id,
        authorizationCode: authResult.code!,
      );
      
      // 4. Store tokens securely
      await _repository.storeTokens(bank.id, tokens);
      
      // 5. Fetch account details and save
      final accountDetails = await _repository.fetchAccountDetails(bank.id);
      
      return Result.success(accountDetails);
    } on OAuthException catch (e) {
      return Result.failure(AccountLinkingException(e.message));
    }
  }
}

// lib/features/accounts/presentation/screens/link_account_screen.dart
class LinkAccountScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banks = ref.watch(availableBanksProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Link Bank Account')),
      body: banks.when(
        data: (bankList) => ListView.builder(
          itemCount: bankList.length,
          itemBuilder: (context, index) {
            final bank = bankList[index];
            return BankListTile(
              bank: bank,
              onTap: bank.isAvailable 
                ? () => _initiateOAuth(context, ref, bank)
                : null,
            );
          },
        ),
        loading: () => const LoadingIndicator(),
        error: (e, s) => ErrorWidget(error: e),
      ),
    );
  }
  
  Future<void> _initiateOAuth(
    BuildContext context, 
    WidgetRef ref, 
    Bank bank,
  ) async {
    // Show consent dialog first
    final consent = await showConsentDialog(context, bank);
    if (!consent) return;
    
    final result = await ref.read(linkBankAccountProvider(bank).future);
    
    result.fold(
      onSuccess: (account) {
        context.showSuccessSnackbar('${bank.name} linked successfully!');
        context.pop();
      },
      onFailure: (error) {
        context.showErrorDialog(error.message);
      },
    );
  }
}
```

### Backend API (Go/Fiber)

```go
// internal/accounts/handler.go
func (h *AccountHandler) GetAuthorizationURL(c *fiber.Ctx) error {
    bankID := c.Params("bankId")
    userID := c.Locals("userId").(string)
    
    // Generate state for CSRF protection
    state := generateSecureState()
    h.stateStore.Set(state, userID, 5*time.Minute)
    
    // Get bank-specific OAuth config
    config := h.bankConfigs[bankID]
    
    authURL := fmt.Sprintf(
        "%s?client_id=%s&redirect_uri=%s&state=%s&scope=read:transactions",
        config.AuthorizationEndpoint,
        config.ClientID,
        url.QueryEscape(config.RedirectURI),
        state,
    )
    
    return c.JSON(fiber.Map{"authorization_url": authURL})
}

func (h *AccountHandler) ExchangeToken(c *fiber.Ctx) error {
    var req ExchangeTokenRequest
    if err := c.BodyParser(&req); err != nil {
        return c.Status(400).JSON(ErrorResponse{Error: "Invalid request"})
    }
    
    // Verify state
    userID, valid := h.stateStore.Get(req.State)
    if !valid {
        return c.Status(400).JSON(ErrorResponse{Error: "Invalid state"})
    }
    
    // Exchange code for tokens with bank
    tokens, err := h.bankService.ExchangeCode(req.BankID, req.Code)
    if err != nil {
        return c.Status(500).JSON(ErrorResponse{Error: "Token exchange failed"})
    }
    
    // Store tokens (encrypted) in database
    if err := h.tokenStore.Save(userID, req.BankID, tokens); err != nil {
        return c.Status(500).JSON(ErrorResponse{Error: "Failed to save tokens"})
    }
    
    // Trigger initial sync
    h.syncQueue.Enqueue(SyncJob{UserID: userID, BankID: req.BankID})
    
    return c.JSON(fiber.Map{"success": true})
}
```

---

## Definition of Done

- [ ] Bank selection UI with logos and availability status
- [ ] OAuth 2.0 flow implemented with secure WebView
- [ ] Consent screen shown before bank redirect
- [ ] Authorization code exchange via backend
- [ ] Tokens stored securely (encrypted in backend DB)
- [ ] Account details fetched and displayed
- [ ] Error handling for all failure scenarios
- [ ] Token refresh mechanism implemented
- [ ] Account unlinking with token revocation
- [ ] Unit tests for use cases
- [ ] Integration tests for OAuth flow
- [ ] Security audit passed
- [ ] Code reviewed and approved

---

## Test Cases

### Unit Tests
```dart
group('LinkBankAccountUseCase', () {
  test('successful linking stores tokens and returns account', () async {
    when(mockOAuthService.authenticate(any)).thenReturn(
      AuthResult(code: 'auth_code_123')
    );
    when(mockRepository.exchangeCodeForTokens(any, any)).thenReturn(
      Tokens(accessToken: 'access', refreshToken: 'refresh')
    );
    
    final result = await useCase.execute(testBank);
    
    expect(result.isSuccess, true);
    verify(mockRepository.storeTokens(any, any)).called(1);
  });
  
  test('cancelled OAuth returns failure', () async {
    when(mockOAuthService.authenticate(any)).thenReturn(
      AuthResult(isCancelled: true)
    );
    
    final result = await useCase.execute(testBank);
    
    expect(result.isFailure, true);
    expect(result.error, isA<UserCancelledException>());
  });
});
```

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| SS-001 | Blocks | Project setup required |
| SS-002 | Blocks | Database for storing account info |
| SS-201 | Blocks | Auth service (backend) |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-011 | HDFC Bank integration |
| SS-012 | ICICI Bank integration |
| SS-030 | Transaction sync |

---

## Security Considerations

1. **No credentials stored**: User authenticates directly with bank
2. **CSRF protection**: State parameter in OAuth flow
3. **Token encryption**: All tokens encrypted at rest
4. **Secure WebView**: Certificate pinning, no JS injection
5. **Audit logging**: All linking attempts logged

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| Bank selection UI | 4 |
| OAuth service (Flutter) | 6 |
| Secure WebView component | 4 |
| Backend OAuth endpoints | 6 |
| Token storage/management | 4 |
| Error handling | 3 |
| Unlinking flow | 3 |
| Testing | 6 |
| Security review | 2 |
| **Total** | **38 hours** |

---

*Created: 2026-02-04 | Last Updated: 2026-02-04*
