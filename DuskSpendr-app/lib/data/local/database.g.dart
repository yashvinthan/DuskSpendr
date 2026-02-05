// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionTypeDb, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TransactionTypeDb>($TransactionsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionCategoryDb, int>
      category = GeneratedColumn<int>('category', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TransactionCategoryDb>(
              $TransactionsTable.$convertercategory);
  static const VerificationMeta _merchantNameMeta =
      const VerificationMeta('merchantName');
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
      'merchant_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionSourceDb, int> source =
      GeneratedColumn<int>('source', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TransactionSourceDb>(
              $TransactionsTable.$convertersource);
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMethodDb?, int>
      paymentMethod = GeneratedColumn<int>('payment_method', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<PaymentMethodDb?>(
              $TransactionsTable.$converterpaymentMethodn);
  static const VerificationMeta _linkedAccountIdMeta =
      const VerificationMeta('linkedAccountId');
  @override
  late final GeneratedColumn<String> linkedAccountId = GeneratedColumn<String>(
      'linked_account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
      'reference_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryConfidenceMeta =
      const VerificationMeta('categoryConfidence');
  @override
  late final GeneratedColumn<double> categoryConfidence =
      GeneratedColumn<double>('category_confidence', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
      'is_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_recurring" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _recurringPatternIdMeta =
      const VerificationMeta('recurringPatternId');
  @override
  late final GeneratedColumn<String> recurringPatternId =
      GeneratedColumn<String>('recurring_pattern_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSharedMeta =
      const VerificationMeta('isShared');
  @override
  late final GeneratedColumn<bool> isShared = GeneratedColumn<bool>(
      'is_shared', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_shared" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sharedExpenseIdMeta =
      const VerificationMeta('sharedExpenseId');
  @override
  late final GeneratedColumn<String> sharedExpenseId = GeneratedColumn<String>(
      'shared_expense_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        amountPaisa,
        type,
        category,
        merchantName,
        description,
        timestamp,
        source,
        paymentMethod,
        linkedAccountId,
        referenceId,
        categoryConfidence,
        isRecurring,
        recurringPatternId,
        isShared,
        sharedExpenseId,
        tags,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
          _merchantNameMeta,
          merchantName.isAcceptableOrUnknown(
              data['merchant_name']!, _merchantNameMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('linked_account_id')) {
      context.handle(
          _linkedAccountIdMeta,
          linkedAccountId.isAcceptableOrUnknown(
              data['linked_account_id']!, _linkedAccountIdMeta));
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    }
    if (data.containsKey('category_confidence')) {
      context.handle(
          _categoryConfidenceMeta,
          categoryConfidence.isAcceptableOrUnknown(
              data['category_confidence']!, _categoryConfidenceMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    if (data.containsKey('recurring_pattern_id')) {
      context.handle(
          _recurringPatternIdMeta,
          recurringPatternId.isAcceptableOrUnknown(
              data['recurring_pattern_id']!, _recurringPatternIdMeta));
    }
    if (data.containsKey('is_shared')) {
      context.handle(_isSharedMeta,
          isShared.isAcceptableOrUnknown(data['is_shared']!, _isSharedMeta));
    }
    if (data.containsKey('shared_expense_id')) {
      context.handle(
          _sharedExpenseIdMeta,
          sharedExpenseId.isAcceptableOrUnknown(
              data['shared_expense_id']!, _sharedExpenseIdMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      type: $TransactionsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      category: $TransactionsTable.$convertercategory.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category'])!),
      merchantName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant_name']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      source: $TransactionsTable.$convertersource.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source'])!),
      paymentMethod: $TransactionsTable.$converterpaymentMethodn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}payment_method'])),
      linkedAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_account_id']),
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_id']),
      categoryConfidence: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}category_confidence']),
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurringPatternId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurring_pattern_id']),
      isShared: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_shared'])!,
      sharedExpenseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shared_expense_id']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionTypeDb, int, int> $convertertype =
      const EnumIndexConverter<TransactionTypeDb>(TransactionTypeDb.values);
  static JsonTypeConverter2<TransactionCategoryDb, int, int>
      $convertercategory = const EnumIndexConverter<TransactionCategoryDb>(
          TransactionCategoryDb.values);
  static JsonTypeConverter2<TransactionSourceDb, int, int> $convertersource =
      const EnumIndexConverter<TransactionSourceDb>(TransactionSourceDb.values);
  static JsonTypeConverter2<PaymentMethodDb, int, int> $converterpaymentMethod =
      const EnumIndexConverter<PaymentMethodDb>(PaymentMethodDb.values);
  static JsonTypeConverter2<PaymentMethodDb?, int?, int?>
      $converterpaymentMethodn =
      JsonTypeConverter2.asNullable($converterpaymentMethod);
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final int amountPaisa;
  final TransactionTypeDb type;
  final TransactionCategoryDb category;
  final String? merchantName;
  final String? description;
  final DateTime timestamp;
  final TransactionSourceDb source;
  final PaymentMethodDb? paymentMethod;
  final String? linkedAccountId;
  final String? referenceId;
  final double? categoryConfidence;
  final bool isRecurring;
  final String? recurringPatternId;
  final bool isShared;
  final String? sharedExpenseId;
  final String tags;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TransactionRow(
      {required this.id,
      required this.amountPaisa,
      required this.type,
      required this.category,
      this.merchantName,
      this.description,
      required this.timestamp,
      required this.source,
      this.paymentMethod,
      this.linkedAccountId,
      this.referenceId,
      this.categoryConfidence,
      required this.isRecurring,
      this.recurringPatternId,
      required this.isShared,
      this.sharedExpenseId,
      required this.tags,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    {
      map['type'] =
          Variable<int>($TransactionsTable.$convertertype.toSql(type));
    }
    {
      map['category'] =
          Variable<int>($TransactionsTable.$convertercategory.toSql(category));
    }
    if (!nullToAbsent || merchantName != null) {
      map['merchant_name'] = Variable<String>(merchantName);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    {
      map['source'] =
          Variable<int>($TransactionsTable.$convertersource.toSql(source));
    }
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<int>(
          $TransactionsTable.$converterpaymentMethodn.toSql(paymentMethod));
    }
    if (!nullToAbsent || linkedAccountId != null) {
      map['linked_account_id'] = Variable<String>(linkedAccountId);
    }
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    if (!nullToAbsent || categoryConfidence != null) {
      map['category_confidence'] = Variable<double>(categoryConfidence);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurringPatternId != null) {
      map['recurring_pattern_id'] = Variable<String>(recurringPatternId);
    }
    map['is_shared'] = Variable<bool>(isShared);
    if (!nullToAbsent || sharedExpenseId != null) {
      map['shared_expense_id'] = Variable<String>(sharedExpenseId);
    }
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amountPaisa: Value(amountPaisa),
      type: Value(type),
      category: Value(category),
      merchantName: merchantName == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      timestamp: Value(timestamp),
      source: Value(source),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      linkedAccountId: linkedAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAccountId),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      categoryConfidence: categoryConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryConfidence),
      isRecurring: Value(isRecurring),
      recurringPatternId: recurringPatternId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringPatternId),
      isShared: Value(isShared),
      sharedExpenseId: sharedExpenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedExpenseId),
      tags: Value(tags),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      type: $TransactionsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      category: $TransactionsTable.$convertercategory
          .fromJson(serializer.fromJson<int>(json['category'])),
      merchantName: serializer.fromJson<String?>(json['merchantName']),
      description: serializer.fromJson<String?>(json['description']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      source: $TransactionsTable.$convertersource
          .fromJson(serializer.fromJson<int>(json['source'])),
      paymentMethod: $TransactionsTable.$converterpaymentMethodn
          .fromJson(serializer.fromJson<int?>(json['paymentMethod'])),
      linkedAccountId: serializer.fromJson<String?>(json['linkedAccountId']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      categoryConfidence:
          serializer.fromJson<double?>(json['categoryConfidence']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurringPatternId:
          serializer.fromJson<String?>(json['recurringPatternId']),
      isShared: serializer.fromJson<bool>(json['isShared']),
      sharedExpenseId: serializer.fromJson<String?>(json['sharedExpenseId']),
      tags: serializer.fromJson<String>(json['tags']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'type': serializer
          .toJson<int>($TransactionsTable.$convertertype.toJson(type)),
      'category': serializer
          .toJson<int>($TransactionsTable.$convertercategory.toJson(category)),
      'merchantName': serializer.toJson<String?>(merchantName),
      'description': serializer.toJson<String?>(description),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'source': serializer
          .toJson<int>($TransactionsTable.$convertersource.toJson(source)),
      'paymentMethod': serializer.toJson<int?>(
          $TransactionsTable.$converterpaymentMethodn.toJson(paymentMethod)),
      'linkedAccountId': serializer.toJson<String?>(linkedAccountId),
      'referenceId': serializer.toJson<String?>(referenceId),
      'categoryConfidence': serializer.toJson<double?>(categoryConfidence),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurringPatternId': serializer.toJson<String?>(recurringPatternId),
      'isShared': serializer.toJson<bool>(isShared),
      'sharedExpenseId': serializer.toJson<String?>(sharedExpenseId),
      'tags': serializer.toJson<String>(tags),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransactionRow copyWith(
          {String? id,
          int? amountPaisa,
          TransactionTypeDb? type,
          TransactionCategoryDb? category,
          Value<String?> merchantName = const Value.absent(),
          Value<String?> description = const Value.absent(),
          DateTime? timestamp,
          TransactionSourceDb? source,
          Value<PaymentMethodDb?> paymentMethod = const Value.absent(),
          Value<String?> linkedAccountId = const Value.absent(),
          Value<String?> referenceId = const Value.absent(),
          Value<double?> categoryConfidence = const Value.absent(),
          bool? isRecurring,
          Value<String?> recurringPatternId = const Value.absent(),
          bool? isShared,
          Value<String?> sharedExpenseId = const Value.absent(),
          String? tags,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TransactionRow(
        id: id ?? this.id,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        type: type ?? this.type,
        category: category ?? this.category,
        merchantName:
            merchantName.present ? merchantName.value : this.merchantName,
        description: description.present ? description.value : this.description,
        timestamp: timestamp ?? this.timestamp,
        source: source ?? this.source,
        paymentMethod:
            paymentMethod.present ? paymentMethod.value : this.paymentMethod,
        linkedAccountId: linkedAccountId.present
            ? linkedAccountId.value
            : this.linkedAccountId,
        referenceId: referenceId.present ? referenceId.value : this.referenceId,
        categoryConfidence: categoryConfidence.present
            ? categoryConfidence.value
            : this.categoryConfidence,
        isRecurring: isRecurring ?? this.isRecurring,
        recurringPatternId: recurringPatternId.present
            ? recurringPatternId.value
            : this.recurringPatternId,
        isShared: isShared ?? this.isShared,
        sharedExpenseId: sharedExpenseId.present
            ? sharedExpenseId.value
            : this.sharedExpenseId,
        tags: tags ?? this.tags,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      description:
          data.description.present ? data.description.value : this.description,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      source: data.source.present ? data.source.value : this.source,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      linkedAccountId: data.linkedAccountId.present
          ? data.linkedAccountId.value
          : this.linkedAccountId,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      categoryConfidence: data.categoryConfidence.present
          ? data.categoryConfidence.value
          : this.categoryConfidence,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      recurringPatternId: data.recurringPatternId.present
          ? data.recurringPatternId.value
          : this.recurringPatternId,
      isShared: data.isShared.present ? data.isShared.value : this.isShared,
      sharedExpenseId: data.sharedExpenseId.present
          ? data.sharedExpenseId.value
          : this.sharedExpenseId,
      tags: data.tags.present ? data.tags.value : this.tags,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('merchantName: $merchantName, ')
          ..write('description: $description, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('referenceId: $referenceId, ')
          ..write('categoryConfidence: $categoryConfidence, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringPatternId: $recurringPatternId, ')
          ..write('isShared: $isShared, ')
          ..write('sharedExpenseId: $sharedExpenseId, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      amountPaisa,
      type,
      category,
      merchantName,
      description,
      timestamp,
      source,
      paymentMethod,
      linkedAccountId,
      referenceId,
      categoryConfidence,
      isRecurring,
      recurringPatternId,
      isShared,
      sharedExpenseId,
      tags,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.amountPaisa == this.amountPaisa &&
          other.type == this.type &&
          other.category == this.category &&
          other.merchantName == this.merchantName &&
          other.description == this.description &&
          other.timestamp == this.timestamp &&
          other.source == this.source &&
          other.paymentMethod == this.paymentMethod &&
          other.linkedAccountId == this.linkedAccountId &&
          other.referenceId == this.referenceId &&
          other.categoryConfidence == this.categoryConfidence &&
          other.isRecurring == this.isRecurring &&
          other.recurringPatternId == this.recurringPatternId &&
          other.isShared == this.isShared &&
          other.sharedExpenseId == this.sharedExpenseId &&
          other.tags == this.tags &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<int> amountPaisa;
  final Value<TransactionTypeDb> type;
  final Value<TransactionCategoryDb> category;
  final Value<String?> merchantName;
  final Value<String?> description;
  final Value<DateTime> timestamp;
  final Value<TransactionSourceDb> source;
  final Value<PaymentMethodDb?> paymentMethod;
  final Value<String?> linkedAccountId;
  final Value<String?> referenceId;
  final Value<double?> categoryConfidence;
  final Value<bool> isRecurring;
  final Value<String?> recurringPatternId;
  final Value<bool> isShared;
  final Value<String?> sharedExpenseId;
  final Value<String> tags;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.description = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.source = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.categoryConfidence = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringPatternId = const Value.absent(),
    this.isShared = const Value.absent(),
    this.sharedExpenseId = const Value.absent(),
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required int amountPaisa,
    required TransactionTypeDb type,
    required TransactionCategoryDb category,
    this.merchantName = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime timestamp,
    required TransactionSourceDb source,
    this.paymentMethod = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.categoryConfidence = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringPatternId = const Value.absent(),
    this.isShared = const Value.absent(),
    this.sharedExpenseId = const Value.absent(),
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        amountPaisa = Value(amountPaisa),
        type = Value(type),
        category = Value(category),
        timestamp = Value(timestamp),
        source = Value(source),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<int>? amountPaisa,
    Expression<int>? type,
    Expression<int>? category,
    Expression<String>? merchantName,
    Expression<String>? description,
    Expression<DateTime>? timestamp,
    Expression<int>? source,
    Expression<int>? paymentMethod,
    Expression<String>? linkedAccountId,
    Expression<String>? referenceId,
    Expression<double>? categoryConfidence,
    Expression<bool>? isRecurring,
    Expression<String>? recurringPatternId,
    Expression<bool>? isShared,
    Expression<String>? sharedExpenseId,
    Expression<String>? tags,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (merchantName != null) 'merchant_name': merchantName,
      if (description != null) 'description': description,
      if (timestamp != null) 'timestamp': timestamp,
      if (source != null) 'source': source,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (linkedAccountId != null) 'linked_account_id': linkedAccountId,
      if (referenceId != null) 'reference_id': referenceId,
      if (categoryConfidence != null) 'category_confidence': categoryConfidence,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurringPatternId != null)
        'recurring_pattern_id': recurringPatternId,
      if (isShared != null) 'is_shared': isShared,
      if (sharedExpenseId != null) 'shared_expense_id': sharedExpenseId,
      if (tags != null) 'tags': tags,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<int>? amountPaisa,
      Value<TransactionTypeDb>? type,
      Value<TransactionCategoryDb>? category,
      Value<String?>? merchantName,
      Value<String?>? description,
      Value<DateTime>? timestamp,
      Value<TransactionSourceDb>? source,
      Value<PaymentMethodDb?>? paymentMethod,
      Value<String?>? linkedAccountId,
      Value<String?>? referenceId,
      Value<double?>? categoryConfidence,
      Value<bool>? isRecurring,
      Value<String?>? recurringPatternId,
      Value<bool>? isShared,
      Value<String?>? sharedExpenseId,
      Value<String>? tags,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      type: type ?? this.type,
      category: category ?? this.category,
      merchantName: merchantName ?? this.merchantName,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      linkedAccountId: linkedAccountId ?? this.linkedAccountId,
      referenceId: referenceId ?? this.referenceId,
      categoryConfidence: categoryConfidence ?? this.categoryConfidence,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPatternId: recurringPatternId ?? this.recurringPatternId,
      isShared: isShared ?? this.isShared,
      sharedExpenseId: sharedExpenseId ?? this.sharedExpenseId,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($TransactionsTable.$convertertype.toSql(type.value));
    }
    if (category.present) {
      map['category'] = Variable<int>(
          $TransactionsTable.$convertercategory.toSql(category.value));
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(
          $TransactionsTable.$convertersource.toSql(source.value));
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<int>($TransactionsTable
          .$converterpaymentMethodn
          .toSql(paymentMethod.value));
    }
    if (linkedAccountId.present) {
      map['linked_account_id'] = Variable<String>(linkedAccountId.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (categoryConfidence.present) {
      map['category_confidence'] = Variable<double>(categoryConfidence.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurringPatternId.present) {
      map['recurring_pattern_id'] = Variable<String>(recurringPatternId.value);
    }
    if (isShared.present) {
      map['is_shared'] = Variable<bool>(isShared.value);
    }
    if (sharedExpenseId.present) {
      map['shared_expense_id'] = Variable<String>(sharedExpenseId.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('merchantName: $merchantName, ')
          ..write('description: $description, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('referenceId: $referenceId, ')
          ..write('categoryConfidence: $categoryConfidence, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringPatternId: $recurringPatternId, ')
          ..write('isShared: $isShared, ')
          ..write('sharedExpenseId: $sharedExpenseId, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LinkedAccountsTable extends LinkedAccounts
    with TableInfo<$LinkedAccountsTable, LinkedAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LinkedAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<AccountProviderDb, int> provider =
      GeneratedColumn<int>('provider', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AccountProviderDb>(
              $LinkedAccountsTable.$converterprovider);
  static const VerificationMeta _accountNumberMeta =
      const VerificationMeta('accountNumber');
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
      'account_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountNameMeta =
      const VerificationMeta('accountName');
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
      'account_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upiIdMeta = const VerificationMeta('upiId');
  @override
  late final GeneratedColumn<String> upiId = GeneratedColumn<String>(
      'upi_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _balancePaisaMeta =
      const VerificationMeta('balancePaisa');
  @override
  late final GeneratedColumn<int> balancePaisa = GeneratedColumn<int>(
      'balance_paisa', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _balanceUpdatedAtMeta =
      const VerificationMeta('balanceUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> balanceUpdatedAt =
      GeneratedColumn<DateTime>('balance_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<AccountStatusDb, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AccountStatusDb>(
              $LinkedAccountsTable.$converterstatus);
  static const VerificationMeta _accessTokenMeta =
      const VerificationMeta('accessToken');
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
      'access_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _refreshTokenMeta =
      const VerificationMeta('refreshToken');
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
      'refresh_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tokenExpiresAtMeta =
      const VerificationMeta('tokenExpiresAt');
  @override
  late final GeneratedColumn<DateTime> tokenExpiresAt =
      GeneratedColumn<DateTime>('token_expires_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _linkedAtMeta =
      const VerificationMeta('linkedAt');
  @override
  late final GeneratedColumn<DateTime> linkedAt = GeneratedColumn<DateTime>(
      'linked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isPrimaryMeta =
      const VerificationMeta('isPrimary');
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
      'is_primary', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_primary" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        provider,
        accountNumber,
        accountName,
        upiId,
        balancePaisa,
        balanceUpdatedAt,
        status,
        accessToken,
        refreshToken,
        tokenExpiresAt,
        lastSyncedAt,
        linkedAt,
        isPrimary,
        metadata
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'linked_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<LinkedAccountRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_number')) {
      context.handle(
          _accountNumberMeta,
          accountNumber.isAcceptableOrUnknown(
              data['account_number']!, _accountNumberMeta));
    }
    if (data.containsKey('account_name')) {
      context.handle(
          _accountNameMeta,
          accountName.isAcceptableOrUnknown(
              data['account_name']!, _accountNameMeta));
    }
    if (data.containsKey('upi_id')) {
      context.handle(
          _upiIdMeta, upiId.isAcceptableOrUnknown(data['upi_id']!, _upiIdMeta));
    }
    if (data.containsKey('balance_paisa')) {
      context.handle(
          _balancePaisaMeta,
          balancePaisa.isAcceptableOrUnknown(
              data['balance_paisa']!, _balancePaisaMeta));
    }
    if (data.containsKey('balance_updated_at')) {
      context.handle(
          _balanceUpdatedAtMeta,
          balanceUpdatedAt.isAcceptableOrUnknown(
              data['balance_updated_at']!, _balanceUpdatedAtMeta));
    }
    if (data.containsKey('access_token')) {
      context.handle(
          _accessTokenMeta,
          accessToken.isAcceptableOrUnknown(
              data['access_token']!, _accessTokenMeta));
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
          _refreshTokenMeta,
          refreshToken.isAcceptableOrUnknown(
              data['refresh_token']!, _refreshTokenMeta));
    }
    if (data.containsKey('token_expires_at')) {
      context.handle(
          _tokenExpiresAtMeta,
          tokenExpiresAt.isAcceptableOrUnknown(
              data['token_expires_at']!, _tokenExpiresAtMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    if (data.containsKey('linked_at')) {
      context.handle(_linkedAtMeta,
          linkedAt.isAcceptableOrUnknown(data['linked_at']!, _linkedAtMeta));
    } else if (isInserting) {
      context.missing(_linkedAtMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(_isPrimaryMeta,
          isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinkedAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LinkedAccountRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      provider: $LinkedAccountsTable.$converterprovider.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}provider'])!),
      accountNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_number']),
      accountName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_name']),
      upiId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}upi_id']),
      balancePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}balance_paisa']),
      balanceUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}balance_updated_at']),
      status: $LinkedAccountsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      accessToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}access_token']),
      refreshToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}refresh_token']),
      tokenExpiresAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}token_expires_at']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at'])!,
      linkedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}linked_at'])!,
      isPrimary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_primary'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
    );
  }

  @override
  $LinkedAccountsTable createAlias(String alias) {
    return $LinkedAccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountProviderDb, int, int> $converterprovider =
      const EnumIndexConverter<AccountProviderDb>(AccountProviderDb.values);
  static JsonTypeConverter2<AccountStatusDb, int, int> $converterstatus =
      const EnumIndexConverter<AccountStatusDb>(AccountStatusDb.values);
}

class LinkedAccountRow extends DataClass
    implements Insertable<LinkedAccountRow> {
  final String id;
  final AccountProviderDb provider;
  final String? accountNumber;
  final String? accountName;
  final String? upiId;
  final int? balancePaisa;
  final DateTime? balanceUpdatedAt;
  final AccountStatusDb status;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiresAt;
  final DateTime lastSyncedAt;
  final DateTime linkedAt;
  final bool isPrimary;
  final String? metadata;
  const LinkedAccountRow(
      {required this.id,
      required this.provider,
      this.accountNumber,
      this.accountName,
      this.upiId,
      this.balancePaisa,
      this.balanceUpdatedAt,
      required this.status,
      this.accessToken,
      this.refreshToken,
      this.tokenExpiresAt,
      required this.lastSyncedAt,
      required this.linkedAt,
      required this.isPrimary,
      this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['provider'] = Variable<int>(
          $LinkedAccountsTable.$converterprovider.toSql(provider));
    }
    if (!nullToAbsent || accountNumber != null) {
      map['account_number'] = Variable<String>(accountNumber);
    }
    if (!nullToAbsent || accountName != null) {
      map['account_name'] = Variable<String>(accountName);
    }
    if (!nullToAbsent || upiId != null) {
      map['upi_id'] = Variable<String>(upiId);
    }
    if (!nullToAbsent || balancePaisa != null) {
      map['balance_paisa'] = Variable<int>(balancePaisa);
    }
    if (!nullToAbsent || balanceUpdatedAt != null) {
      map['balance_updated_at'] = Variable<DateTime>(balanceUpdatedAt);
    }
    {
      map['status'] =
          Variable<int>($LinkedAccountsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || accessToken != null) {
      map['access_token'] = Variable<String>(accessToken);
    }
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    if (!nullToAbsent || tokenExpiresAt != null) {
      map['token_expires_at'] = Variable<DateTime>(tokenExpiresAt);
    }
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    map['linked_at'] = Variable<DateTime>(linkedAt);
    map['is_primary'] = Variable<bool>(isPrimary);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  LinkedAccountsCompanion toCompanion(bool nullToAbsent) {
    return LinkedAccountsCompanion(
      id: Value(id),
      provider: Value(provider),
      accountNumber: accountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumber),
      accountName: accountName == null && nullToAbsent
          ? const Value.absent()
          : Value(accountName),
      upiId:
          upiId == null && nullToAbsent ? const Value.absent() : Value(upiId),
      balancePaisa: balancePaisa == null && nullToAbsent
          ? const Value.absent()
          : Value(balancePaisa),
      balanceUpdatedAt: balanceUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceUpdatedAt),
      status: Value(status),
      accessToken: accessToken == null && nullToAbsent
          ? const Value.absent()
          : Value(accessToken),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
      tokenExpiresAt: tokenExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenExpiresAt),
      lastSyncedAt: Value(lastSyncedAt),
      linkedAt: Value(linkedAt),
      isPrimary: Value(isPrimary),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory LinkedAccountRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinkedAccountRow(
      id: serializer.fromJson<String>(json['id']),
      provider: $LinkedAccountsTable.$converterprovider
          .fromJson(serializer.fromJson<int>(json['provider'])),
      accountNumber: serializer.fromJson<String?>(json['accountNumber']),
      accountName: serializer.fromJson<String?>(json['accountName']),
      upiId: serializer.fromJson<String?>(json['upiId']),
      balancePaisa: serializer.fromJson<int?>(json['balancePaisa']),
      balanceUpdatedAt:
          serializer.fromJson<DateTime?>(json['balanceUpdatedAt']),
      status: $LinkedAccountsTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      accessToken: serializer.fromJson<String?>(json['accessToken']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
      tokenExpiresAt: serializer.fromJson<DateTime?>(json['tokenExpiresAt']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
      linkedAt: serializer.fromJson<DateTime>(json['linkedAt']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'provider': serializer.toJson<int>(
          $LinkedAccountsTable.$converterprovider.toJson(provider)),
      'accountNumber': serializer.toJson<String?>(accountNumber),
      'accountName': serializer.toJson<String?>(accountName),
      'upiId': serializer.toJson<String?>(upiId),
      'balancePaisa': serializer.toJson<int?>(balancePaisa),
      'balanceUpdatedAt': serializer.toJson<DateTime?>(balanceUpdatedAt),
      'status': serializer
          .toJson<int>($LinkedAccountsTable.$converterstatus.toJson(status)),
      'accessToken': serializer.toJson<String?>(accessToken),
      'refreshToken': serializer.toJson<String?>(refreshToken),
      'tokenExpiresAt': serializer.toJson<DateTime?>(tokenExpiresAt),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
      'linkedAt': serializer.toJson<DateTime>(linkedAt),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  LinkedAccountRow copyWith(
          {String? id,
          AccountProviderDb? provider,
          Value<String?> accountNumber = const Value.absent(),
          Value<String?> accountName = const Value.absent(),
          Value<String?> upiId = const Value.absent(),
          Value<int?> balancePaisa = const Value.absent(),
          Value<DateTime?> balanceUpdatedAt = const Value.absent(),
          AccountStatusDb? status,
          Value<String?> accessToken = const Value.absent(),
          Value<String?> refreshToken = const Value.absent(),
          Value<DateTime?> tokenExpiresAt = const Value.absent(),
          DateTime? lastSyncedAt,
          DateTime? linkedAt,
          bool? isPrimary,
          Value<String?> metadata = const Value.absent()}) =>
      LinkedAccountRow(
        id: id ?? this.id,
        provider: provider ?? this.provider,
        accountNumber:
            accountNumber.present ? accountNumber.value : this.accountNumber,
        accountName: accountName.present ? accountName.value : this.accountName,
        upiId: upiId.present ? upiId.value : this.upiId,
        balancePaisa:
            balancePaisa.present ? balancePaisa.value : this.balancePaisa,
        balanceUpdatedAt: balanceUpdatedAt.present
            ? balanceUpdatedAt.value
            : this.balanceUpdatedAt,
        status: status ?? this.status,
        accessToken: accessToken.present ? accessToken.value : this.accessToken,
        refreshToken:
            refreshToken.present ? refreshToken.value : this.refreshToken,
        tokenExpiresAt:
            tokenExpiresAt.present ? tokenExpiresAt.value : this.tokenExpiresAt,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        linkedAt: linkedAt ?? this.linkedAt,
        isPrimary: isPrimary ?? this.isPrimary,
        metadata: metadata.present ? metadata.value : this.metadata,
      );
  LinkedAccountRow copyWithCompanion(LinkedAccountsCompanion data) {
    return LinkedAccountRow(
      id: data.id.present ? data.id.value : this.id,
      provider: data.provider.present ? data.provider.value : this.provider,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      accountName:
          data.accountName.present ? data.accountName.value : this.accountName,
      upiId: data.upiId.present ? data.upiId.value : this.upiId,
      balancePaisa: data.balancePaisa.present
          ? data.balancePaisa.value
          : this.balancePaisa,
      balanceUpdatedAt: data.balanceUpdatedAt.present
          ? data.balanceUpdatedAt.value
          : this.balanceUpdatedAt,
      status: data.status.present ? data.status.value : this.status,
      accessToken:
          data.accessToken.present ? data.accessToken.value : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      tokenExpiresAt: data.tokenExpiresAt.present
          ? data.tokenExpiresAt.value
          : this.tokenExpiresAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      linkedAt: data.linkedAt.present ? data.linkedAt.value : this.linkedAt,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LinkedAccountRow(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('accountName: $accountName, ')
          ..write('upiId: $upiId, ')
          ..write('balancePaisa: $balancePaisa, ')
          ..write('balanceUpdatedAt: $balanceUpdatedAt, ')
          ..write('status: $status, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('tokenExpiresAt: $tokenExpiresAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('linkedAt: $linkedAt, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      provider,
      accountNumber,
      accountName,
      upiId,
      balancePaisa,
      balanceUpdatedAt,
      status,
      accessToken,
      refreshToken,
      tokenExpiresAt,
      lastSyncedAt,
      linkedAt,
      isPrimary,
      metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinkedAccountRow &&
          other.id == this.id &&
          other.provider == this.provider &&
          other.accountNumber == this.accountNumber &&
          other.accountName == this.accountName &&
          other.upiId == this.upiId &&
          other.balancePaisa == this.balancePaisa &&
          other.balanceUpdatedAt == this.balanceUpdatedAt &&
          other.status == this.status &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.tokenExpiresAt == this.tokenExpiresAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.linkedAt == this.linkedAt &&
          other.isPrimary == this.isPrimary &&
          other.metadata == this.metadata);
}

class LinkedAccountsCompanion extends UpdateCompanion<LinkedAccountRow> {
  final Value<String> id;
  final Value<AccountProviderDb> provider;
  final Value<String?> accountNumber;
  final Value<String?> accountName;
  final Value<String?> upiId;
  final Value<int?> balancePaisa;
  final Value<DateTime?> balanceUpdatedAt;
  final Value<AccountStatusDb> status;
  final Value<String?> accessToken;
  final Value<String?> refreshToken;
  final Value<DateTime?> tokenExpiresAt;
  final Value<DateTime> lastSyncedAt;
  final Value<DateTime> linkedAt;
  final Value<bool> isPrimary;
  final Value<String?> metadata;
  final Value<int> rowid;
  const LinkedAccountsCompanion({
    this.id = const Value.absent(),
    this.provider = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.accountName = const Value.absent(),
    this.upiId = const Value.absent(),
    this.balancePaisa = const Value.absent(),
    this.balanceUpdatedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.tokenExpiresAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.linkedAt = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LinkedAccountsCompanion.insert({
    required String id,
    required AccountProviderDb provider,
    this.accountNumber = const Value.absent(),
    this.accountName = const Value.absent(),
    this.upiId = const Value.absent(),
    this.balancePaisa = const Value.absent(),
    this.balanceUpdatedAt = const Value.absent(),
    required AccountStatusDb status,
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.tokenExpiresAt = const Value.absent(),
    required DateTime lastSyncedAt,
    required DateTime linkedAt,
    this.isPrimary = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        provider = Value(provider),
        status = Value(status),
        lastSyncedAt = Value(lastSyncedAt),
        linkedAt = Value(linkedAt);
  static Insertable<LinkedAccountRow> custom({
    Expression<String>? id,
    Expression<int>? provider,
    Expression<String>? accountNumber,
    Expression<String>? accountName,
    Expression<String>? upiId,
    Expression<int>? balancePaisa,
    Expression<DateTime>? balanceUpdatedAt,
    Expression<int>? status,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<DateTime>? tokenExpiresAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? linkedAt,
    Expression<bool>? isPrimary,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provider != null) 'provider': provider,
      if (accountNumber != null) 'account_number': accountNumber,
      if (accountName != null) 'account_name': accountName,
      if (upiId != null) 'upi_id': upiId,
      if (balancePaisa != null) 'balance_paisa': balancePaisa,
      if (balanceUpdatedAt != null) 'balance_updated_at': balanceUpdatedAt,
      if (status != null) 'status': status,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (tokenExpiresAt != null) 'token_expires_at': tokenExpiresAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (linkedAt != null) 'linked_at': linkedAt,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LinkedAccountsCompanion copyWith(
      {Value<String>? id,
      Value<AccountProviderDb>? provider,
      Value<String?>? accountNumber,
      Value<String?>? accountName,
      Value<String?>? upiId,
      Value<int?>? balancePaisa,
      Value<DateTime?>? balanceUpdatedAt,
      Value<AccountStatusDb>? status,
      Value<String?>? accessToken,
      Value<String?>? refreshToken,
      Value<DateTime?>? tokenExpiresAt,
      Value<DateTime>? lastSyncedAt,
      Value<DateTime>? linkedAt,
      Value<bool>? isPrimary,
      Value<String?>? metadata,
      Value<int>? rowid}) {
    return LinkedAccountsCompanion(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      upiId: upiId ?? this.upiId,
      balancePaisa: balancePaisa ?? this.balancePaisa,
      balanceUpdatedAt: balanceUpdatedAt ?? this.balanceUpdatedAt,
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      linkedAt: linkedAt ?? this.linkedAt,
      isPrimary: isPrimary ?? this.isPrimary,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (provider.present) {
      map['provider'] = Variable<int>(
          $LinkedAccountsTable.$converterprovider.toSql(provider.value));
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (upiId.present) {
      map['upi_id'] = Variable<String>(upiId.value);
    }
    if (balancePaisa.present) {
      map['balance_paisa'] = Variable<int>(balancePaisa.value);
    }
    if (balanceUpdatedAt.present) {
      map['balance_updated_at'] = Variable<DateTime>(balanceUpdatedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $LinkedAccountsTable.$converterstatus.toSql(status.value));
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (tokenExpiresAt.present) {
      map['token_expires_at'] = Variable<DateTime>(tokenExpiresAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (linkedAt.present) {
      map['linked_at'] = Variable<DateTime>(linkedAt.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LinkedAccountsCompanion(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('accountName: $accountName, ')
          ..write('upiId: $upiId, ')
          ..write('balancePaisa: $balancePaisa, ')
          ..write('balanceUpdatedAt: $balanceUpdatedAt, ')
          ..write('status: $status, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('tokenExpiresAt: $tokenExpiresAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('linkedAt: $linkedAt, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _limitPaisaMeta =
      const VerificationMeta('limitPaisa');
  @override
  late final GeneratedColumn<int> limitPaisa = GeneratedColumn<int>(
      'limit_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _spentPaisaMeta =
      const VerificationMeta('spentPaisa');
  @override
  late final GeneratedColumn<int> spentPaisa = GeneratedColumn<int>(
      'spent_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumnWithTypeConverter<BudgetPeriodDb, int> period =
      GeneratedColumn<int>('period', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<BudgetPeriodDb>($BudgetsTable.$converterperiod);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionCategoryDb?, int>
      category = GeneratedColumn<int>('category', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<TransactionCategoryDb?>(
              $BudgetsTable.$convertercategoryn);
  static const VerificationMeta _alertThresholdMeta =
      const VerificationMeta('alertThreshold');
  @override
  late final GeneratedColumn<double> alertThreshold = GeneratedColumn<double>(
      'alert_threshold', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.8));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        limitPaisa,
        spentPaisa,
        period,
        category,
        alertThreshold,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('limit_paisa')) {
      context.handle(
          _limitPaisaMeta,
          limitPaisa.isAcceptableOrUnknown(
              data['limit_paisa']!, _limitPaisaMeta));
    } else if (isInserting) {
      context.missing(_limitPaisaMeta);
    }
    if (data.containsKey('spent_paisa')) {
      context.handle(
          _spentPaisaMeta,
          spentPaisa.isAcceptableOrUnknown(
              data['spent_paisa']!, _spentPaisaMeta));
    }
    if (data.containsKey('alert_threshold')) {
      context.handle(
          _alertThresholdMeta,
          alertThreshold.isAcceptableOrUnknown(
              data['alert_threshold']!, _alertThresholdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      limitPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}limit_paisa'])!,
      spentPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}spent_paisa'])!,
      period: $BudgetsTable.$converterperiod.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period'])!),
      category: $BudgetsTable.$convertercategoryn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category'])),
      alertThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}alert_threshold'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BudgetPeriodDb, int, int> $converterperiod =
      const EnumIndexConverter<BudgetPeriodDb>(BudgetPeriodDb.values);
  static JsonTypeConverter2<TransactionCategoryDb, int, int>
      $convertercategory = const EnumIndexConverter<TransactionCategoryDb>(
          TransactionCategoryDb.values);
  static JsonTypeConverter2<TransactionCategoryDb?, int?, int?>
      $convertercategoryn = JsonTypeConverter2.asNullable($convertercategory);
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final String id;
  final String name;
  final int limitPaisa;
  final int spentPaisa;
  final BudgetPeriodDb period;
  final TransactionCategoryDb? category;
  final double alertThreshold;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BudgetRow(
      {required this.id,
      required this.name,
      required this.limitPaisa,
      required this.spentPaisa,
      required this.period,
      this.category,
      required this.alertThreshold,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['limit_paisa'] = Variable<int>(limitPaisa);
    map['spent_paisa'] = Variable<int>(spentPaisa);
    {
      map['period'] =
          Variable<int>($BudgetsTable.$converterperiod.toSql(period));
    }
    if (!nullToAbsent || category != null) {
      map['category'] =
          Variable<int>($BudgetsTable.$convertercategoryn.toSql(category));
    }
    map['alert_threshold'] = Variable<double>(alertThreshold);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      name: Value(name),
      limitPaisa: Value(limitPaisa),
      spentPaisa: Value(spentPaisa),
      period: Value(period),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      alertThreshold: Value(alertThreshold),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      limitPaisa: serializer.fromJson<int>(json['limitPaisa']),
      spentPaisa: serializer.fromJson<int>(json['spentPaisa']),
      period: $BudgetsTable.$converterperiod
          .fromJson(serializer.fromJson<int>(json['period'])),
      category: $BudgetsTable.$convertercategoryn
          .fromJson(serializer.fromJson<int?>(json['category'])),
      alertThreshold: serializer.fromJson<double>(json['alertThreshold']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'limitPaisa': serializer.toJson<int>(limitPaisa),
      'spentPaisa': serializer.toJson<int>(spentPaisa),
      'period':
          serializer.toJson<int>($BudgetsTable.$converterperiod.toJson(period)),
      'category': serializer
          .toJson<int?>($BudgetsTable.$convertercategoryn.toJson(category)),
      'alertThreshold': serializer.toJson<double>(alertThreshold),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetRow copyWith(
          {String? id,
          String? name,
          int? limitPaisa,
          int? spentPaisa,
          BudgetPeriodDb? period,
          Value<TransactionCategoryDb?> category = const Value.absent(),
          double? alertThreshold,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BudgetRow(
        id: id ?? this.id,
        name: name ?? this.name,
        limitPaisa: limitPaisa ?? this.limitPaisa,
        spentPaisa: spentPaisa ?? this.spentPaisa,
        period: period ?? this.period,
        category: category.present ? category.value : this.category,
        alertThreshold: alertThreshold ?? this.alertThreshold,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      limitPaisa:
          data.limitPaisa.present ? data.limitPaisa.value : this.limitPaisa,
      spentPaisa:
          data.spentPaisa.present ? data.spentPaisa.value : this.spentPaisa,
      period: data.period.present ? data.period.value : this.period,
      category: data.category.present ? data.category.value : this.category,
      alertThreshold: data.alertThreshold.present
          ? data.alertThreshold.value
          : this.alertThreshold,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('limitPaisa: $limitPaisa, ')
          ..write('spentPaisa: $spentPaisa, ')
          ..write('period: $period, ')
          ..write('category: $category, ')
          ..write('alertThreshold: $alertThreshold, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, limitPaisa, spentPaisa, period,
      category, alertThreshold, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.limitPaisa == this.limitPaisa &&
          other.spentPaisa == this.spentPaisa &&
          other.period == this.period &&
          other.category == this.category &&
          other.alertThreshold == this.alertThreshold &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> limitPaisa;
  final Value<int> spentPaisa;
  final Value<BudgetPeriodDb> period;
  final Value<TransactionCategoryDb?> category;
  final Value<double> alertThreshold;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.limitPaisa = const Value.absent(),
    this.spentPaisa = const Value.absent(),
    this.period = const Value.absent(),
    this.category = const Value.absent(),
    this.alertThreshold = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String name,
    required int limitPaisa,
    this.spentPaisa = const Value.absent(),
    required BudgetPeriodDb period,
    this.category = const Value.absent(),
    this.alertThreshold = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        limitPaisa = Value(limitPaisa),
        period = Value(period),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<BudgetRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? limitPaisa,
    Expression<int>? spentPaisa,
    Expression<int>? period,
    Expression<int>? category,
    Expression<double>? alertThreshold,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (limitPaisa != null) 'limit_paisa': limitPaisa,
      if (spentPaisa != null) 'spent_paisa': spentPaisa,
      if (period != null) 'period': period,
      if (category != null) 'category': category,
      if (alertThreshold != null) 'alert_threshold': alertThreshold,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? limitPaisa,
      Value<int>? spentPaisa,
      Value<BudgetPeriodDb>? period,
      Value<TransactionCategoryDb?>? category,
      Value<double>? alertThreshold,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BudgetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      limitPaisa: limitPaisa ?? this.limitPaisa,
      spentPaisa: spentPaisa ?? this.spentPaisa,
      period: period ?? this.period,
      category: category ?? this.category,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (limitPaisa.present) {
      map['limit_paisa'] = Variable<int>(limitPaisa.value);
    }
    if (spentPaisa.present) {
      map['spent_paisa'] = Variable<int>(spentPaisa.value);
    }
    if (period.present) {
      map['period'] =
          Variable<int>($BudgetsTable.$converterperiod.toSql(period.value));
    }
    if (category.present) {
      map['category'] = Variable<int>(
          $BudgetsTable.$convertercategoryn.toSql(category.value));
    }
    if (alertThreshold.present) {
      map['alert_threshold'] = Variable<double>(alertThreshold.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('limitPaisa: $limitPaisa, ')
          ..write('spentPaisa: $spentPaisa, ')
          ..write('period: $period, ')
          ..write('category: $category, ')
          ..write('alertThreshold: $alertThreshold, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomCategoriesTable extends CustomCategories
    with TableInfo<$CustomCategoriesTable, CustomCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameHiMeta = const VerificationMeta('nameHi');
  @override
  late final GeneratedColumn<String> nameHi = GeneratedColumn<String>(
      'name_hi', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconCodePointMeta =
      const VerificationMeta('iconCodePoint');
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
      'icon_code_point', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _keywordsMeta =
      const VerificationMeta('keywords');
  @override
  late final GeneratedColumn<String> keywords = GeneratedColumn<String>(
      'keywords', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, nameHi, iconCodePoint, colorValue, keywords, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_categories';
  @override
  VerificationContext validateIntegrity(Insertable<CustomCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_hi')) {
      context.handle(_nameHiMeta,
          nameHi.isAcceptableOrUnknown(data['name_hi']!, _nameHiMeta));
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
          _iconCodePointMeta,
          iconCodePoint.isAcceptableOrUnknown(
              data['icon_code_point']!, _iconCodePointMeta));
    } else if (isInserting) {
      context.missing(_iconCodePointMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('keywords')) {
      context.handle(_keywordsMeta,
          keywords.isAcceptableOrUnknown(data['keywords']!, _keywordsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameHi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_hi']),
      iconCodePoint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_code_point'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      keywords: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keywords'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomCategoriesTable createAlias(String alias) {
    return $CustomCategoriesTable(attachedDatabase, alias);
  }
}

class CustomCategory extends DataClass implements Insertable<CustomCategory> {
  final String id;
  final String name;
  final String? nameHi;
  final int iconCodePoint;
  final int colorValue;
  final String keywords;
  final DateTime createdAt;
  const CustomCategory(
      {required this.id,
      required this.name,
      this.nameHi,
      required this.iconCodePoint,
      required this.colorValue,
      required this.keywords,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameHi != null) {
      map['name_hi'] = Variable<String>(nameHi);
    }
    map['icon_code_point'] = Variable<int>(iconCodePoint);
    map['color_value'] = Variable<int>(colorValue);
    map['keywords'] = Variable<String>(keywords);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomCategoriesCompanion toCompanion(bool nullToAbsent) {
    return CustomCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      nameHi:
          nameHi == null && nullToAbsent ? const Value.absent() : Value(nameHi),
      iconCodePoint: Value(iconCodePoint),
      colorValue: Value(colorValue),
      keywords: Value(keywords),
      createdAt: Value(createdAt),
    );
  }

  factory CustomCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameHi: serializer.fromJson<String?>(json['nameHi']),
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      keywords: serializer.fromJson<String>(json['keywords']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameHi': serializer.toJson<String?>(nameHi),
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
      'colorValue': serializer.toJson<int>(colorValue),
      'keywords': serializer.toJson<String>(keywords),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomCategory copyWith(
          {String? id,
          String? name,
          Value<String?> nameHi = const Value.absent(),
          int? iconCodePoint,
          int? colorValue,
          String? keywords,
          DateTime? createdAt}) =>
      CustomCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        nameHi: nameHi.present ? nameHi.value : this.nameHi,
        iconCodePoint: iconCodePoint ?? this.iconCodePoint,
        colorValue: colorValue ?? this.colorValue,
        keywords: keywords ?? this.keywords,
        createdAt: createdAt ?? this.createdAt,
      );
  CustomCategory copyWithCompanion(CustomCategoriesCompanion data) {
    return CustomCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameHi: data.nameHi.present ? data.nameHi.value : this.nameHi,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameHi: $nameHi, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('colorValue: $colorValue, ')
          ..write('keywords: $keywords, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, nameHi, iconCodePoint, colorValue, keywords, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameHi == this.nameHi &&
          other.iconCodePoint == this.iconCodePoint &&
          other.colorValue == this.colorValue &&
          other.keywords == this.keywords &&
          other.createdAt == this.createdAt);
}

class CustomCategoriesCompanion extends UpdateCompanion<CustomCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameHi;
  final Value<int> iconCodePoint;
  final Value<int> colorValue;
  final Value<String> keywords;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameHi = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.keywords = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomCategoriesCompanion.insert({
    required String id,
    required String name,
    this.nameHi = const Value.absent(),
    required int iconCodePoint,
    required int colorValue,
    this.keywords = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        iconCodePoint = Value(iconCodePoint),
        colorValue = Value(colorValue),
        createdAt = Value(createdAt);
  static Insertable<CustomCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameHi,
    Expression<int>? iconCodePoint,
    Expression<int>? colorValue,
    Expression<String>? keywords,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameHi != null) 'name_hi': nameHi,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (colorValue != null) 'color_value': colorValue,
      if (keywords != null) 'keywords': keywords,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? nameHi,
      Value<int>? iconCodePoint,
      Value<int>? colorValue,
      Value<String>? keywords,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CustomCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameHi: nameHi ?? this.nameHi,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      keywords: keywords ?? this.keywords,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameHi.present) {
      map['name_hi'] = Variable<String>(nameHi.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(keywords.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameHi: $nameHi, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('colorValue: $colorValue, ')
          ..write('keywords: $keywords, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MerchantMappingsTable extends MerchantMappings
    with TableInfo<$MerchantMappingsTable, MerchantMapping> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _merchantPatternMeta =
      const VerificationMeta('merchantPattern');
  @override
  late final GeneratedColumn<String> merchantPattern = GeneratedColumn<String>(
      'merchant_pattern', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionCategoryDb, int>
      category = GeneratedColumn<int>('category', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TransactionCategoryDb>(
              $MerchantMappingsTable.$convertercategory);
  static const VerificationMeta _correctionCountMeta =
      const VerificationMeta('correctionCount');
  @override
  late final GeneratedColumn<int> correctionCount = GeneratedColumn<int>(
      'correction_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _lastUsedMeta =
      const VerificationMeta('lastUsed');
  @override
  late final GeneratedColumn<DateTime> lastUsed = GeneratedColumn<DateTime>(
      'last_used', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [merchantPattern, category, correctionCount, lastUsed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchant_mappings';
  @override
  VerificationContext validateIntegrity(Insertable<MerchantMapping> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('merchant_pattern')) {
      context.handle(
          _merchantPatternMeta,
          merchantPattern.isAcceptableOrUnknown(
              data['merchant_pattern']!, _merchantPatternMeta));
    } else if (isInserting) {
      context.missing(_merchantPatternMeta);
    }
    if (data.containsKey('correction_count')) {
      context.handle(
          _correctionCountMeta,
          correctionCount.isAcceptableOrUnknown(
              data['correction_count']!, _correctionCountMeta));
    }
    if (data.containsKey('last_used')) {
      context.handle(_lastUsedMeta,
          lastUsed.isAcceptableOrUnknown(data['last_used']!, _lastUsedMeta));
    } else if (isInserting) {
      context.missing(_lastUsedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {merchantPattern};
  @override
  MerchantMapping map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MerchantMapping(
      merchantPattern: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}merchant_pattern'])!,
      category: $MerchantMappingsTable.$convertercategory.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}category'])!),
      correctionCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correction_count'])!,
      lastUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used'])!,
    );
  }

  @override
  $MerchantMappingsTable createAlias(String alias) {
    return $MerchantMappingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionCategoryDb, int, int>
      $convertercategory = const EnumIndexConverter<TransactionCategoryDb>(
          TransactionCategoryDb.values);
}

class MerchantMapping extends DataClass implements Insertable<MerchantMapping> {
  final String merchantPattern;
  final TransactionCategoryDb category;
  final int correctionCount;
  final DateTime lastUsed;
  const MerchantMapping(
      {required this.merchantPattern,
      required this.category,
      required this.correctionCount,
      required this.lastUsed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['merchant_pattern'] = Variable<String>(merchantPattern);
    {
      map['category'] = Variable<int>(
          $MerchantMappingsTable.$convertercategory.toSql(category));
    }
    map['correction_count'] = Variable<int>(correctionCount);
    map['last_used'] = Variable<DateTime>(lastUsed);
    return map;
  }

  MerchantMappingsCompanion toCompanion(bool nullToAbsent) {
    return MerchantMappingsCompanion(
      merchantPattern: Value(merchantPattern),
      category: Value(category),
      correctionCount: Value(correctionCount),
      lastUsed: Value(lastUsed),
    );
  }

  factory MerchantMapping.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MerchantMapping(
      merchantPattern: serializer.fromJson<String>(json['merchantPattern']),
      category: $MerchantMappingsTable.$convertercategory
          .fromJson(serializer.fromJson<int>(json['category'])),
      correctionCount: serializer.fromJson<int>(json['correctionCount']),
      lastUsed: serializer.fromJson<DateTime>(json['lastUsed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'merchantPattern': serializer.toJson<String>(merchantPattern),
      'category': serializer.toJson<int>(
          $MerchantMappingsTable.$convertercategory.toJson(category)),
      'correctionCount': serializer.toJson<int>(correctionCount),
      'lastUsed': serializer.toJson<DateTime>(lastUsed),
    };
  }

  MerchantMapping copyWith(
          {String? merchantPattern,
          TransactionCategoryDb? category,
          int? correctionCount,
          DateTime? lastUsed}) =>
      MerchantMapping(
        merchantPattern: merchantPattern ?? this.merchantPattern,
        category: category ?? this.category,
        correctionCount: correctionCount ?? this.correctionCount,
        lastUsed: lastUsed ?? this.lastUsed,
      );
  MerchantMapping copyWithCompanion(MerchantMappingsCompanion data) {
    return MerchantMapping(
      merchantPattern: data.merchantPattern.present
          ? data.merchantPattern.value
          : this.merchantPattern,
      category: data.category.present ? data.category.value : this.category,
      correctionCount: data.correctionCount.present
          ? data.correctionCount.value
          : this.correctionCount,
      lastUsed: data.lastUsed.present ? data.lastUsed.value : this.lastUsed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MerchantMapping(')
          ..write('merchantPattern: $merchantPattern, ')
          ..write('category: $category, ')
          ..write('correctionCount: $correctionCount, ')
          ..write('lastUsed: $lastUsed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(merchantPattern, category, correctionCount, lastUsed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MerchantMapping &&
          other.merchantPattern == this.merchantPattern &&
          other.category == this.category &&
          other.correctionCount == this.correctionCount &&
          other.lastUsed == this.lastUsed);
}

class MerchantMappingsCompanion extends UpdateCompanion<MerchantMapping> {
  final Value<String> merchantPattern;
  final Value<TransactionCategoryDb> category;
  final Value<int> correctionCount;
  final Value<DateTime> lastUsed;
  final Value<int> rowid;
  const MerchantMappingsCompanion({
    this.merchantPattern = const Value.absent(),
    this.category = const Value.absent(),
    this.correctionCount = const Value.absent(),
    this.lastUsed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MerchantMappingsCompanion.insert({
    required String merchantPattern,
    required TransactionCategoryDb category,
    this.correctionCount = const Value.absent(),
    required DateTime lastUsed,
    this.rowid = const Value.absent(),
  })  : merchantPattern = Value(merchantPattern),
        category = Value(category),
        lastUsed = Value(lastUsed);
  static Insertable<MerchantMapping> custom({
    Expression<String>? merchantPattern,
    Expression<int>? category,
    Expression<int>? correctionCount,
    Expression<DateTime>? lastUsed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (merchantPattern != null) 'merchant_pattern': merchantPattern,
      if (category != null) 'category': category,
      if (correctionCount != null) 'correction_count': correctionCount,
      if (lastUsed != null) 'last_used': lastUsed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MerchantMappingsCompanion copyWith(
      {Value<String>? merchantPattern,
      Value<TransactionCategoryDb>? category,
      Value<int>? correctionCount,
      Value<DateTime>? lastUsed,
      Value<int>? rowid}) {
    return MerchantMappingsCompanion(
      merchantPattern: merchantPattern ?? this.merchantPattern,
      category: category ?? this.category,
      correctionCount: correctionCount ?? this.correctionCount,
      lastUsed: lastUsed ?? this.lastUsed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (merchantPattern.present) {
      map['merchant_pattern'] = Variable<String>(merchantPattern.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
          $MerchantMappingsTable.$convertercategory.toSql(category.value));
    }
    if (correctionCount.present) {
      map['correction_count'] = Variable<int>(correctionCount.value);
    }
    if (lastUsed.present) {
      map['last_used'] = Variable<DateTime>(lastUsed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantMappingsCompanion(')
          ..write('merchantPattern: $merchantPattern, ')
          ..write('category: $category, ')
          ..write('correctionCount: $correctionCount, ')
          ..write('lastUsed: $lastUsed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringPatternsTable extends RecurringPatterns
    with TableInfo<$RecurringPatternsTable, RecurringPattern> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringPatternsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionCategoryDb, int>
      category = GeneratedColumn<int>('category', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TransactionCategoryDb>(
              $RecurringPatternsTable.$convertercategory);
  static const VerificationMeta _frequencyDaysMeta =
      const VerificationMeta('frequencyDays');
  @override
  late final GeneratedColumn<int> frequencyDays = GeneratedColumn<int>(
      'frequency_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nextExpectedMeta =
      const VerificationMeta('nextExpected');
  @override
  late final GeneratedColumn<DateTime> nextExpected = GeneratedColumn<DateTime>(
      'next_expected', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _linkedAccountIdMeta =
      const VerificationMeta('linkedAccountId');
  @override
  late final GeneratedColumn<String> linkedAccountId = GeneratedColumn<String>(
      'linked_account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        amountPaisa,
        category,
        frequencyDays,
        nextExpected,
        linkedAccountId,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_patterns';
  @override
  VerificationContext validateIntegrity(Insertable<RecurringPattern> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('frequency_days')) {
      context.handle(
          _frequencyDaysMeta,
          frequencyDays.isAcceptableOrUnknown(
              data['frequency_days']!, _frequencyDaysMeta));
    } else if (isInserting) {
      context.missing(_frequencyDaysMeta);
    }
    if (data.containsKey('next_expected')) {
      context.handle(
          _nextExpectedMeta,
          nextExpected.isAcceptableOrUnknown(
              data['next_expected']!, _nextExpectedMeta));
    } else if (isInserting) {
      context.missing(_nextExpectedMeta);
    }
    if (data.containsKey('linked_account_id')) {
      context.handle(
          _linkedAccountIdMeta,
          linkedAccountId.isAcceptableOrUnknown(
              data['linked_account_id']!, _linkedAccountIdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringPattern map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringPattern(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      category: $RecurringPatternsTable.$convertercategory.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}category'])!),
      frequencyDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frequency_days'])!,
      nextExpected: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_expected'])!,
      linkedAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_account_id']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $RecurringPatternsTable createAlias(String alias) {
    return $RecurringPatternsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionCategoryDb, int, int>
      $convertercategory = const EnumIndexConverter<TransactionCategoryDb>(
          TransactionCategoryDb.values);
}

class RecurringPattern extends DataClass
    implements Insertable<RecurringPattern> {
  final String id;
  final String name;
  final int amountPaisa;
  final TransactionCategoryDb category;
  final int frequencyDays;
  final DateTime nextExpected;
  final String? linkedAccountId;
  final bool isActive;
  const RecurringPattern(
      {required this.id,
      required this.name,
      required this.amountPaisa,
      required this.category,
      required this.frequencyDays,
      required this.nextExpected,
      this.linkedAccountId,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    {
      map['category'] = Variable<int>(
          $RecurringPatternsTable.$convertercategory.toSql(category));
    }
    map['frequency_days'] = Variable<int>(frequencyDays);
    map['next_expected'] = Variable<DateTime>(nextExpected);
    if (!nullToAbsent || linkedAccountId != null) {
      map['linked_account_id'] = Variable<String>(linkedAccountId);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RecurringPatternsCompanion toCompanion(bool nullToAbsent) {
    return RecurringPatternsCompanion(
      id: Value(id),
      name: Value(name),
      amountPaisa: Value(amountPaisa),
      category: Value(category),
      frequencyDays: Value(frequencyDays),
      nextExpected: Value(nextExpected),
      linkedAccountId: linkedAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAccountId),
      isActive: Value(isActive),
    );
  }

  factory RecurringPattern.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringPattern(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      category: $RecurringPatternsTable.$convertercategory
          .fromJson(serializer.fromJson<int>(json['category'])),
      frequencyDays: serializer.fromJson<int>(json['frequencyDays']),
      nextExpected: serializer.fromJson<DateTime>(json['nextExpected']),
      linkedAccountId: serializer.fromJson<String?>(json['linkedAccountId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'category': serializer.toJson<int>(
          $RecurringPatternsTable.$convertercategory.toJson(category)),
      'frequencyDays': serializer.toJson<int>(frequencyDays),
      'nextExpected': serializer.toJson<DateTime>(nextExpected),
      'linkedAccountId': serializer.toJson<String?>(linkedAccountId),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  RecurringPattern copyWith(
          {String? id,
          String? name,
          int? amountPaisa,
          TransactionCategoryDb? category,
          int? frequencyDays,
          DateTime? nextExpected,
          Value<String?> linkedAccountId = const Value.absent(),
          bool? isActive}) =>
      RecurringPattern(
        id: id ?? this.id,
        name: name ?? this.name,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        category: category ?? this.category,
        frequencyDays: frequencyDays ?? this.frequencyDays,
        nextExpected: nextExpected ?? this.nextExpected,
        linkedAccountId: linkedAccountId.present
            ? linkedAccountId.value
            : this.linkedAccountId,
        isActive: isActive ?? this.isActive,
      );
  RecurringPattern copyWithCompanion(RecurringPatternsCompanion data) {
    return RecurringPattern(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      category: data.category.present ? data.category.value : this.category,
      frequencyDays: data.frequencyDays.present
          ? data.frequencyDays.value
          : this.frequencyDays,
      nextExpected: data.nextExpected.present
          ? data.nextExpected.value
          : this.nextExpected,
      linkedAccountId: data.linkedAccountId.present
          ? data.linkedAccountId.value
          : this.linkedAccountId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPattern(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('category: $category, ')
          ..write('frequencyDays: $frequencyDays, ')
          ..write('nextExpected: $nextExpected, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amountPaisa, category,
      frequencyDays, nextExpected, linkedAccountId, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringPattern &&
          other.id == this.id &&
          other.name == this.name &&
          other.amountPaisa == this.amountPaisa &&
          other.category == this.category &&
          other.frequencyDays == this.frequencyDays &&
          other.nextExpected == this.nextExpected &&
          other.linkedAccountId == this.linkedAccountId &&
          other.isActive == this.isActive);
}

class RecurringPatternsCompanion extends UpdateCompanion<RecurringPattern> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> amountPaisa;
  final Value<TransactionCategoryDb> category;
  final Value<int> frequencyDays;
  final Value<DateTime> nextExpected;
  final Value<String?> linkedAccountId;
  final Value<bool> isActive;
  final Value<int> rowid;
  const RecurringPatternsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.category = const Value.absent(),
    this.frequencyDays = const Value.absent(),
    this.nextExpected = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringPatternsCompanion.insert({
    required String id,
    required String name,
    required int amountPaisa,
    required TransactionCategoryDb category,
    required int frequencyDays,
    required DateTime nextExpected,
    this.linkedAccountId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        amountPaisa = Value(amountPaisa),
        category = Value(category),
        frequencyDays = Value(frequencyDays),
        nextExpected = Value(nextExpected);
  static Insertable<RecurringPattern> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? amountPaisa,
    Expression<int>? category,
    Expression<int>? frequencyDays,
    Expression<DateTime>? nextExpected,
    Expression<String>? linkedAccountId,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (category != null) 'category': category,
      if (frequencyDays != null) 'frequency_days': frequencyDays,
      if (nextExpected != null) 'next_expected': nextExpected,
      if (linkedAccountId != null) 'linked_account_id': linkedAccountId,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringPatternsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? amountPaisa,
      Value<TransactionCategoryDb>? category,
      Value<int>? frequencyDays,
      Value<DateTime>? nextExpected,
      Value<String?>? linkedAccountId,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return RecurringPatternsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      category: category ?? this.category,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      nextExpected: nextExpected ?? this.nextExpected,
      linkedAccountId: linkedAccountId ?? this.linkedAccountId,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
          $RecurringPatternsTable.$convertercategory.toSql(category.value));
    }
    if (frequencyDays.present) {
      map['frequency_days'] = Variable<int>(frequencyDays.value);
    }
    if (nextExpected.present) {
      map['next_expected'] = Variable<DateTime>(nextExpected.value);
    }
    if (linkedAccountId.present) {
      map['linked_account_id'] = Variable<String>(linkedAccountId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPatternsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('category: $category, ')
          ..write('frequencyDays: $frequencyDays, ')
          ..write('nextExpected: $nextExpected, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<AuditLogTypeDb, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AuditLogTypeDb>($AuditLogsTable.$convertertype);
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
      'entity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, entity, entityId, details, metadata, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(_entityMeta,
          entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: $AuditLogsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      entity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id']),
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AuditLogTypeDb, int, int> $convertertype =
      const EnumIndexConverter<AuditLogTypeDb>(AuditLogTypeDb.values);
}

class AuditLogRow extends DataClass implements Insertable<AuditLogRow> {
  final String id;
  final AuditLogTypeDb type;
  final String entity;
  final String? entityId;
  final String? details;
  final String? metadata;
  final DateTime createdAt;
  const AuditLogRow(
      {required this.id,
      required this.type,
      required this.entity,
      this.entityId,
      this.details,
      this.metadata,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['type'] = Variable<int>($AuditLogsTable.$convertertype.toSql(type));
    }
    map['entity'] = Variable<String>(entity);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      type: Value(type),
      entity: Value(entity),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogRow(
      id: serializer.fromJson<String>(json['id']),
      type: $AuditLogsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      details: serializer.fromJson<String?>(json['details']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type':
          serializer.toJson<int>($AuditLogsTable.$convertertype.toJson(type)),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String?>(entityId),
      'details': serializer.toJson<String?>(details),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLogRow copyWith(
          {String? id,
          AuditLogTypeDb? type,
          String? entity,
          Value<String?> entityId = const Value.absent(),
          Value<String?> details = const Value.absent(),
          Value<String?> metadata = const Value.absent(),
          DateTime? createdAt}) =>
      AuditLogRow(
        id: id ?? this.id,
        type: type ?? this.type,
        entity: entity ?? this.entity,
        entityId: entityId.present ? entityId.value : this.entityId,
        details: details.present ? details.value : this.details,
        metadata: metadata.present ? metadata.value : this.metadata,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditLogRow copyWithCompanion(AuditLogsCompanion data) {
    return AuditLogRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      details: data.details.present ? data.details.value : this.details,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, entity, entityId, details, metadata, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.details == this.details &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLogRow> {
  final Value<String> id;
  final Value<AuditLogTypeDb> type;
  final Value<String> entity;
  final Value<String?> entityId;
  final Value<String?> details;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    required String id,
    required AuditLogTypeDb type,
    required String entity,
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.metadata = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        entity = Value(entity),
        createdAt = Value(createdAt);
  static Insertable<AuditLogRow> custom({
    Expression<String>? id,
    Expression<int>? type,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? details,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (details != null) 'details': details,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogsCompanion copyWith(
      {Value<String>? id,
      Value<AuditLogTypeDb>? type,
      Value<String>? entity,
      Value<String?>? entityId,
      Value<String?>? details,
      Value<String?>? metadata,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      details: details ?? this.details,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($AuditLogsTable.$convertertype.toSql(type.value));
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrivacyReportsTable extends PrivacyReports
    with TableInfo<$PrivacyReportsTable, PrivacyReportRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrivacyReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reportJsonMeta =
      const VerificationMeta('reportJson');
  @override
  late final GeneratedColumn<String> reportJson = GeneratedColumn<String>(
      'report_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, generatedAt, reportJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'privacy_reports';
  @override
  VerificationContext validateIntegrity(Insertable<PrivacyReportRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('report_json')) {
      context.handle(
          _reportJsonMeta,
          reportJson.isAcceptableOrUnknown(
              data['report_json']!, _reportJsonMeta));
    } else if (isInserting) {
      context.missing(_reportJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrivacyReportRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrivacyReportRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
      reportJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report_json'])!,
    );
  }

  @override
  $PrivacyReportsTable createAlias(String alias) {
    return $PrivacyReportsTable(attachedDatabase, alias);
  }
}

class PrivacyReportRow extends DataClass
    implements Insertable<PrivacyReportRow> {
  final String id;
  final DateTime generatedAt;
  final String reportJson;
  const PrivacyReportRow(
      {required this.id, required this.generatedAt, required this.reportJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['report_json'] = Variable<String>(reportJson);
    return map;
  }

  PrivacyReportsCompanion toCompanion(bool nullToAbsent) {
    return PrivacyReportsCompanion(
      id: Value(id),
      generatedAt: Value(generatedAt),
      reportJson: Value(reportJson),
    );
  }

  factory PrivacyReportRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrivacyReportRow(
      id: serializer.fromJson<String>(json['id']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      reportJson: serializer.fromJson<String>(json['reportJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'reportJson': serializer.toJson<String>(reportJson),
    };
  }

  PrivacyReportRow copyWith(
          {String? id, DateTime? generatedAt, String? reportJson}) =>
      PrivacyReportRow(
        id: id ?? this.id,
        generatedAt: generatedAt ?? this.generatedAt,
        reportJson: reportJson ?? this.reportJson,
      );
  PrivacyReportRow copyWithCompanion(PrivacyReportsCompanion data) {
    return PrivacyReportRow(
      id: data.id.present ? data.id.value : this.id,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      reportJson:
          data.reportJson.present ? data.reportJson.value : this.reportJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrivacyReportRow(')
          ..write('id: $id, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('reportJson: $reportJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, generatedAt, reportJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrivacyReportRow &&
          other.id == this.id &&
          other.generatedAt == this.generatedAt &&
          other.reportJson == this.reportJson);
}

class PrivacyReportsCompanion extends UpdateCompanion<PrivacyReportRow> {
  final Value<String> id;
  final Value<DateTime> generatedAt;
  final Value<String> reportJson;
  final Value<int> rowid;
  const PrivacyReportsCompanion({
    this.id = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.reportJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrivacyReportsCompanion.insert({
    required String id,
    required DateTime generatedAt,
    required String reportJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        generatedAt = Value(generatedAt),
        reportJson = Value(reportJson);
  static Insertable<PrivacyReportRow> custom({
    Expression<String>? id,
    Expression<DateTime>? generatedAt,
    Expression<String>? reportJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (reportJson != null) 'report_json': reportJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrivacyReportsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? generatedAt,
      Value<String>? reportJson,
      Value<int>? rowid}) {
    return PrivacyReportsCompanion(
      id: id ?? this.id,
      generatedAt: generatedAt ?? this.generatedAt,
      reportJson: reportJson ?? this.reportJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (reportJson.present) {
      map['report_json'] = Variable<String>(reportJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivacyReportsCompanion(')
          ..write('id: $id, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('reportJson: $reportJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackupMetadataTable extends BackupMetadata
    with TableInfo<$BackupMetadataTable, BackupMetadataRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sizeBytesMeta =
      const VerificationMeta('sizeBytes');
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
      'size_bytes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _checksumMeta =
      const VerificationMeta('checksum');
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
      'checksum', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isEncryptedMeta =
      const VerificationMeta('isEncrypted');
  @override
  late final GeneratedColumn<bool> isEncrypted = GeneratedColumn<bool>(
      'is_encrypted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_encrypted" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  late final GeneratedColumnWithTypeConverter<BackupStatusDb, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<BackupStatusDb>($BackupMetadataTable.$converterstatus);
  static const VerificationMeta _restoreCountMeta =
      const VerificationMeta('restoreCount');
  @override
  late final GeneratedColumn<int> restoreCount = GeneratedColumn<int>(
      'restore_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastRestoredAtMeta =
      const VerificationMeta('lastRestoredAt');
  @override
  late final GeneratedColumn<DateTime> lastRestoredAt =
      GeneratedColumn<DateTime>('last_restored_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        filePath,
        createdAt,
        sizeBytes,
        checksum,
        version,
        isEncrypted,
        status,
        restoreCount,
        lastRestoredAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<BackupMetadataRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(_sizeBytesMeta,
          sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta));
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(_checksumMeta,
          checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta));
    } else if (isInserting) {
      context.missing(_checksumMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('is_encrypted')) {
      context.handle(
          _isEncryptedMeta,
          isEncrypted.isAcceptableOrUnknown(
              data['is_encrypted']!, _isEncryptedMeta));
    }
    if (data.containsKey('restore_count')) {
      context.handle(
          _restoreCountMeta,
          restoreCount.isAcceptableOrUnknown(
              data['restore_count']!, _restoreCountMeta));
    }
    if (data.containsKey('last_restored_at')) {
      context.handle(
          _lastRestoredAtMeta,
          lastRestoredAt.isAcceptableOrUnknown(
              data['last_restored_at']!, _lastRestoredAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackupMetadataRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupMetadataRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      sizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size_bytes'])!,
      checksum: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checksum'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      isEncrypted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_encrypted'])!,
      status: $BackupMetadataTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      restoreCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}restore_count'])!,
      lastRestoredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_restored_at']),
    );
  }

  @override
  $BackupMetadataTable createAlias(String alias) {
    return $BackupMetadataTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BackupStatusDb, int, int> $converterstatus =
      const EnumIndexConverter<BackupStatusDb>(BackupStatusDb.values);
}

class BackupMetadataRow extends DataClass
    implements Insertable<BackupMetadataRow> {
  final String id;
  final String filePath;
  final DateTime createdAt;
  final int sizeBytes;
  final String checksum;
  final int version;
  final bool isEncrypted;
  final BackupStatusDb status;
  final int restoreCount;
  final DateTime? lastRestoredAt;
  const BackupMetadataRow(
      {required this.id,
      required this.filePath,
      required this.createdAt,
      required this.sizeBytes,
      required this.checksum,
      required this.version,
      required this.isEncrypted,
      required this.status,
      required this.restoreCount,
      this.lastRestoredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['file_path'] = Variable<String>(filePath);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['checksum'] = Variable<String>(checksum);
    map['version'] = Variable<int>(version);
    map['is_encrypted'] = Variable<bool>(isEncrypted);
    {
      map['status'] =
          Variable<int>($BackupMetadataTable.$converterstatus.toSql(status));
    }
    map['restore_count'] = Variable<int>(restoreCount);
    if (!nullToAbsent || lastRestoredAt != null) {
      map['last_restored_at'] = Variable<DateTime>(lastRestoredAt);
    }
    return map;
  }

  BackupMetadataCompanion toCompanion(bool nullToAbsent) {
    return BackupMetadataCompanion(
      id: Value(id),
      filePath: Value(filePath),
      createdAt: Value(createdAt),
      sizeBytes: Value(sizeBytes),
      checksum: Value(checksum),
      version: Value(version),
      isEncrypted: Value(isEncrypted),
      status: Value(status),
      restoreCount: Value(restoreCount),
      lastRestoredAt: lastRestoredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRestoredAt),
    );
  }

  factory BackupMetadataRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupMetadataRow(
      id: serializer.fromJson<String>(json['id']),
      filePath: serializer.fromJson<String>(json['filePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      checksum: serializer.fromJson<String>(json['checksum']),
      version: serializer.fromJson<int>(json['version']),
      isEncrypted: serializer.fromJson<bool>(json['isEncrypted']),
      status: $BackupMetadataTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      restoreCount: serializer.fromJson<int>(json['restoreCount']),
      lastRestoredAt: serializer.fromJson<DateTime?>(json['lastRestoredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'filePath': serializer.toJson<String>(filePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'checksum': serializer.toJson<String>(checksum),
      'version': serializer.toJson<int>(version),
      'isEncrypted': serializer.toJson<bool>(isEncrypted),
      'status': serializer
          .toJson<int>($BackupMetadataTable.$converterstatus.toJson(status)),
      'restoreCount': serializer.toJson<int>(restoreCount),
      'lastRestoredAt': serializer.toJson<DateTime?>(lastRestoredAt),
    };
  }

  BackupMetadataRow copyWith(
          {String? id,
          String? filePath,
          DateTime? createdAt,
          int? sizeBytes,
          String? checksum,
          int? version,
          bool? isEncrypted,
          BackupStatusDb? status,
          int? restoreCount,
          Value<DateTime?> lastRestoredAt = const Value.absent()}) =>
      BackupMetadataRow(
        id: id ?? this.id,
        filePath: filePath ?? this.filePath,
        createdAt: createdAt ?? this.createdAt,
        sizeBytes: sizeBytes ?? this.sizeBytes,
        checksum: checksum ?? this.checksum,
        version: version ?? this.version,
        isEncrypted: isEncrypted ?? this.isEncrypted,
        status: status ?? this.status,
        restoreCount: restoreCount ?? this.restoreCount,
        lastRestoredAt:
            lastRestoredAt.present ? lastRestoredAt.value : this.lastRestoredAt,
      );
  BackupMetadataRow copyWithCompanion(BackupMetadataCompanion data) {
    return BackupMetadataRow(
      id: data.id.present ? data.id.value : this.id,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      version: data.version.present ? data.version.value : this.version,
      isEncrypted:
          data.isEncrypted.present ? data.isEncrypted.value : this.isEncrypted,
      status: data.status.present ? data.status.value : this.status,
      restoreCount: data.restoreCount.present
          ? data.restoreCount.value
          : this.restoreCount,
      lastRestoredAt: data.lastRestoredAt.present
          ? data.lastRestoredAt.value
          : this.lastRestoredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupMetadataRow(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('checksum: $checksum, ')
          ..write('version: $version, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('status: $status, ')
          ..write('restoreCount: $restoreCount, ')
          ..write('lastRestoredAt: $lastRestoredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, filePath, createdAt, sizeBytes, checksum,
      version, isEncrypted, status, restoreCount, lastRestoredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupMetadataRow &&
          other.id == this.id &&
          other.filePath == this.filePath &&
          other.createdAt == this.createdAt &&
          other.sizeBytes == this.sizeBytes &&
          other.checksum == this.checksum &&
          other.version == this.version &&
          other.isEncrypted == this.isEncrypted &&
          other.status == this.status &&
          other.restoreCount == this.restoreCount &&
          other.lastRestoredAt == this.lastRestoredAt);
}

class BackupMetadataCompanion extends UpdateCompanion<BackupMetadataRow> {
  final Value<String> id;
  final Value<String> filePath;
  final Value<DateTime> createdAt;
  final Value<int> sizeBytes;
  final Value<String> checksum;
  final Value<int> version;
  final Value<bool> isEncrypted;
  final Value<BackupStatusDb> status;
  final Value<int> restoreCount;
  final Value<DateTime?> lastRestoredAt;
  final Value<int> rowid;
  const BackupMetadataCompanion({
    this.id = const Value.absent(),
    this.filePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.checksum = const Value.absent(),
    this.version = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.status = const Value.absent(),
    this.restoreCount = const Value.absent(),
    this.lastRestoredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackupMetadataCompanion.insert({
    required String id,
    required String filePath,
    required DateTime createdAt,
    required int sizeBytes,
    required String checksum,
    required int version,
    this.isEncrypted = const Value.absent(),
    required BackupStatusDb status,
    this.restoreCount = const Value.absent(),
    this.lastRestoredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        filePath = Value(filePath),
        createdAt = Value(createdAt),
        sizeBytes = Value(sizeBytes),
        checksum = Value(checksum),
        version = Value(version),
        status = Value(status);
  static Insertable<BackupMetadataRow> custom({
    Expression<String>? id,
    Expression<String>? filePath,
    Expression<DateTime>? createdAt,
    Expression<int>? sizeBytes,
    Expression<String>? checksum,
    Expression<int>? version,
    Expression<bool>? isEncrypted,
    Expression<int>? status,
    Expression<int>? restoreCount,
    Expression<DateTime>? lastRestoredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (filePath != null) 'file_path': filePath,
      if (createdAt != null) 'created_at': createdAt,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (checksum != null) 'checksum': checksum,
      if (version != null) 'version': version,
      if (isEncrypted != null) 'is_encrypted': isEncrypted,
      if (status != null) 'status': status,
      if (restoreCount != null) 'restore_count': restoreCount,
      if (lastRestoredAt != null) 'last_restored_at': lastRestoredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackupMetadataCompanion copyWith(
      {Value<String>? id,
      Value<String>? filePath,
      Value<DateTime>? createdAt,
      Value<int>? sizeBytes,
      Value<String>? checksum,
      Value<int>? version,
      Value<bool>? isEncrypted,
      Value<BackupStatusDb>? status,
      Value<int>? restoreCount,
      Value<DateTime?>? lastRestoredAt,
      Value<int>? rowid}) {
    return BackupMetadataCompanion(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      checksum: checksum ?? this.checksum,
      version: version ?? this.version,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      status: status ?? this.status,
      restoreCount: restoreCount ?? this.restoreCount,
      lastRestoredAt: lastRestoredAt ?? this.lastRestoredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isEncrypted.present) {
      map['is_encrypted'] = Variable<bool>(isEncrypted.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $BackupMetadataTable.$converterstatus.toSql(status.value));
    }
    if (restoreCount.present) {
      map['restore_count'] = Variable<int>(restoreCount.value);
    }
    if (lastRestoredAt.present) {
      map['last_restored_at'] = Variable<DateTime>(lastRestoredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupMetadataCompanion(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('checksum: $checksum, ')
          ..write('version: $version, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('status: $status, ')
          ..write('restoreCount: $restoreCount, ')
          ..write('lastRestoredAt: $lastRestoredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SyncOutboxStatusDb, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SyncOutboxStatusDb>($SyncOutboxTable.$converterstatus);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextAttemptAtMeta =
      const VerificationMeta('nextAttemptAt');
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>('next_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        transactionId,
        status,
        attempts,
        nextAttemptAt,
        lastError,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(Insertable<SyncOutboxRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
          _nextAttemptAtMeta,
          nextAttemptAt.isAcceptableOrUnknown(
              data['next_attempt_at']!, _nextAttemptAtMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {transactionId};
  @override
  SyncOutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxRow(
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id'])!,
      status: $SyncOutboxTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_attempt_at']),
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncOutboxStatusDb, int, int> $converterstatus =
      const EnumIndexConverter<SyncOutboxStatusDb>(SyncOutboxStatusDb.values);
}

class SyncOutboxRow extends DataClass implements Insertable<SyncOutboxRow> {
  final String transactionId;
  final SyncOutboxStatusDb status;
  final int attempts;
  final DateTime? nextAttemptAt;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncOutboxRow(
      {required this.transactionId,
      required this.status,
      required this.attempts,
      this.nextAttemptAt,
      this.lastError,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['transaction_id'] = Variable<String>(transactionId);
    {
      map['status'] =
          Variable<int>($SyncOutboxTable.$converterstatus.toSql(status));
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      transactionId: Value(transactionId),
      status: Value(status),
      attempts: Value(attempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncOutboxRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxRow(
      transactionId: serializer.fromJson<String>(json['transactionId']),
      status: $SyncOutboxTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'transactionId': serializer.toJson<String>(transactionId),
      'status': serializer
          .toJson<int>($SyncOutboxTable.$converterstatus.toJson(status)),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncOutboxRow copyWith(
          {String? transactionId,
          SyncOutboxStatusDb? status,
          int? attempts,
          Value<DateTime?> nextAttemptAt = const Value.absent(),
          Value<String?> lastError = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SyncOutboxRow(
        transactionId: transactionId ?? this.transactionId,
        status: status ?? this.status,
        attempts: attempts ?? this.attempts,
        nextAttemptAt:
            nextAttemptAt.present ? nextAttemptAt.value : this.nextAttemptAt,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncOutboxRow copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxRow(
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxRow(')
          ..write('transactionId: $transactionId, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(transactionId, status, attempts,
      nextAttemptAt, lastError, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxRow &&
          other.transactionId == this.transactionId &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxRow> {
  final Value<String> transactionId;
  final Value<SyncOutboxStatusDb> status;
  final Value<int> attempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.transactionId = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String transactionId,
    required SyncOutboxStatusDb status,
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : transactionId = Value(transactionId),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SyncOutboxRow> custom({
    Expression<String>? transactionId,
    Expression<int>? status,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (transactionId != null) 'transaction_id': transactionId,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith(
      {Value<String>? transactionId,
      Value<SyncOutboxStatusDb>? status,
      Value<int>? attempts,
      Value<DateTime?>? nextAttemptAt,
      Value<String?>? lastError,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncOutboxCompanion(
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (status.present) {
      map['status'] =
          Variable<int>($SyncOutboxTable.$converterstatus.toSql(status.value));
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('transactionId: $transactionId, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BalanceSnapshotsTable extends BalanceSnapshots
    with TableInfo<$BalanceSnapshotsTable, BalanceSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BalanceSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balancePaisaMeta =
      const VerificationMeta('balancePaisa');
  @override
  late final GeneratedColumn<int> balancePaisa = GeneratedColumn<int>(
      'balance_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, accountId, balancePaisa, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'balance_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<BalanceSnapshotRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('balance_paisa')) {
      context.handle(
          _balancePaisaMeta,
          balancePaisa.isAcceptableOrUnknown(
              data['balance_paisa']!, _balancePaisaMeta));
    } else if (isInserting) {
      context.missing(_balancePaisaMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BalanceSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BalanceSnapshotRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      balancePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}balance_paisa'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $BalanceSnapshotsTable createAlias(String alias) {
    return $BalanceSnapshotsTable(attachedDatabase, alias);
  }
}

class BalanceSnapshotRow extends DataClass
    implements Insertable<BalanceSnapshotRow> {
  final String id;
  final String accountId;
  final int balancePaisa;
  final DateTime timestamp;
  const BalanceSnapshotRow(
      {required this.id,
      required this.accountId,
      required this.balancePaisa,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['balance_paisa'] = Variable<int>(balancePaisa);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  BalanceSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return BalanceSnapshotsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      balancePaisa: Value(balancePaisa),
      timestamp: Value(timestamp),
    );
  }

  factory BalanceSnapshotRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BalanceSnapshotRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      balancePaisa: serializer.fromJson<int>(json['balancePaisa']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'balancePaisa': serializer.toJson<int>(balancePaisa),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  BalanceSnapshotRow copyWith(
          {String? id,
          String? accountId,
          int? balancePaisa,
          DateTime? timestamp}) =>
      BalanceSnapshotRow(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        balancePaisa: balancePaisa ?? this.balancePaisa,
        timestamp: timestamp ?? this.timestamp,
      );
  BalanceSnapshotRow copyWithCompanion(BalanceSnapshotsCompanion data) {
    return BalanceSnapshotRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      balancePaisa: data.balancePaisa.present
          ? data.balancePaisa.value
          : this.balancePaisa,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BalanceSnapshotRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('balancePaisa: $balancePaisa, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, balancePaisa, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BalanceSnapshotRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.balancePaisa == this.balancePaisa &&
          other.timestamp == this.timestamp);
}

class BalanceSnapshotsCompanion extends UpdateCompanion<BalanceSnapshotRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<int> balancePaisa;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const BalanceSnapshotsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.balancePaisa = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BalanceSnapshotsCompanion.insert({
    required String id,
    required String accountId,
    required int balancePaisa,
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        balancePaisa = Value(balancePaisa),
        timestamp = Value(timestamp);
  static Insertable<BalanceSnapshotRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<int>? balancePaisa,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (balancePaisa != null) 'balance_paisa': balancePaisa,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BalanceSnapshotsCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<int>? balancePaisa,
      Value<DateTime>? timestamp,
      Value<int>? rowid}) {
    return BalanceSnapshotsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      balancePaisa: balancePaisa ?? this.balancePaisa,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (balancePaisa.present) {
      map['balance_paisa'] = Variable<int>(balancePaisa.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BalanceSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('balancePaisa: $balancePaisa, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillRemindersTable extends BillReminders
    with TableInfo<$BillRemindersTable, BillReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _merchantNameMeta =
      const VerificationMeta('merchantName');
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
      'merchant_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<BillFrequencyDb, int> frequency =
      GeneratedColumn<int>('frequency', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<BillFrequencyDb>(
              $BillRemindersTable.$converterfrequency);
  static const VerificationMeta _nextDueDateMeta =
      const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
      'next_due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reminderDaysBeforeMeta =
      const VerificationMeta('reminderDaysBefore');
  @override
  late final GeneratedColumn<int> reminderDaysBefore = GeneratedColumn<int>(
      'reminder_days_before', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _isAutoDetectedMeta =
      const VerificationMeta('isAutoDetected');
  @override
  late final GeneratedColumn<bool> isAutoDetected = GeneratedColumn<bool>(
      'is_auto_detected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_auto_detected" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _linkedAccountIdMeta =
      const VerificationMeta('linkedAccountId');
  @override
  late final GeneratedColumn<String> linkedAccountId = GeneratedColumn<String>(
      'linked_account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        merchantName,
        amountPaisa,
        frequency,
        nextDueDate,
        reminderDaysBefore,
        isAutoDetected,
        isActive,
        linkedAccountId,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_reminders';
  @override
  VerificationContext validateIntegrity(Insertable<BillReminderRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
          _merchantNameMeta,
          merchantName.isAcceptableOrUnknown(
              data['merchant_name']!, _merchantNameMeta));
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
          _nextDueDateMeta,
          nextDueDate.isAcceptableOrUnknown(
              data['next_due_date']!, _nextDueDateMeta));
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('reminder_days_before')) {
      context.handle(
          _reminderDaysBeforeMeta,
          reminderDaysBefore.isAcceptableOrUnknown(
              data['reminder_days_before']!, _reminderDaysBeforeMeta));
    }
    if (data.containsKey('is_auto_detected')) {
      context.handle(
          _isAutoDetectedMeta,
          isAutoDetected.isAcceptableOrUnknown(
              data['is_auto_detected']!, _isAutoDetectedMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('linked_account_id')) {
      context.handle(
          _linkedAccountIdMeta,
          linkedAccountId.isAcceptableOrUnknown(
              data['linked_account_id']!, _linkedAccountIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillReminderRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      merchantName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant_name']),
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      frequency: $BillRemindersTable.$converterfrequency.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}frequency'])!),
      nextDueDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_due_date'])!,
      reminderDaysBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}reminder_days_before'])!,
      isAutoDetected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_auto_detected'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      linkedAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_account_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BillRemindersTable createAlias(String alias) {
    return $BillRemindersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BillFrequencyDb, int, int> $converterfrequency =
      const EnumIndexConverter<BillFrequencyDb>(BillFrequencyDb.values);
}

class BillReminderRow extends DataClass implements Insertable<BillReminderRow> {
  final String id;
  final String name;
  final String? merchantName;
  final int amountPaisa;
  final BillFrequencyDb frequency;
  final DateTime nextDueDate;
  final int reminderDaysBefore;
  final bool isAutoDetected;
  final bool isActive;
  final String? linkedAccountId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BillReminderRow(
      {required this.id,
      required this.name,
      this.merchantName,
      required this.amountPaisa,
      required this.frequency,
      required this.nextDueDate,
      required this.reminderDaysBefore,
      required this.isAutoDetected,
      required this.isActive,
      this.linkedAccountId,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || merchantName != null) {
      map['merchant_name'] = Variable<String>(merchantName);
    }
    map['amount_paisa'] = Variable<int>(amountPaisa);
    {
      map['frequency'] = Variable<int>(
          $BillRemindersTable.$converterfrequency.toSql(frequency));
    }
    map['next_due_date'] = Variable<DateTime>(nextDueDate);
    map['reminder_days_before'] = Variable<int>(reminderDaysBefore);
    map['is_auto_detected'] = Variable<bool>(isAutoDetected);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || linkedAccountId != null) {
      map['linked_account_id'] = Variable<String>(linkedAccountId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BillRemindersCompanion toCompanion(bool nullToAbsent) {
    return BillRemindersCompanion(
      id: Value(id),
      name: Value(name),
      merchantName: merchantName == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantName),
      amountPaisa: Value(amountPaisa),
      frequency: Value(frequency),
      nextDueDate: Value(nextDueDate),
      reminderDaysBefore: Value(reminderDaysBefore),
      isAutoDetected: Value(isAutoDetected),
      isActive: Value(isActive),
      linkedAccountId: linkedAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAccountId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BillReminderRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillReminderRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      merchantName: serializer.fromJson<String?>(json['merchantName']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      frequency: $BillRemindersTable.$converterfrequency
          .fromJson(serializer.fromJson<int>(json['frequency'])),
      nextDueDate: serializer.fromJson<DateTime>(json['nextDueDate']),
      reminderDaysBefore: serializer.fromJson<int>(json['reminderDaysBefore']),
      isAutoDetected: serializer.fromJson<bool>(json['isAutoDetected']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      linkedAccountId: serializer.fromJson<String?>(json['linkedAccountId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'merchantName': serializer.toJson<String?>(merchantName),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'frequency': serializer.toJson<int>(
          $BillRemindersTable.$converterfrequency.toJson(frequency)),
      'nextDueDate': serializer.toJson<DateTime>(nextDueDate),
      'reminderDaysBefore': serializer.toJson<int>(reminderDaysBefore),
      'isAutoDetected': serializer.toJson<bool>(isAutoDetected),
      'isActive': serializer.toJson<bool>(isActive),
      'linkedAccountId': serializer.toJson<String?>(linkedAccountId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BillReminderRow copyWith(
          {String? id,
          String? name,
          Value<String?> merchantName = const Value.absent(),
          int? amountPaisa,
          BillFrequencyDb? frequency,
          DateTime? nextDueDate,
          int? reminderDaysBefore,
          bool? isAutoDetected,
          bool? isActive,
          Value<String?> linkedAccountId = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BillReminderRow(
        id: id ?? this.id,
        name: name ?? this.name,
        merchantName:
            merchantName.present ? merchantName.value : this.merchantName,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        frequency: frequency ?? this.frequency,
        nextDueDate: nextDueDate ?? this.nextDueDate,
        reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
        isAutoDetected: isAutoDetected ?? this.isAutoDetected,
        isActive: isActive ?? this.isActive,
        linkedAccountId: linkedAccountId.present
            ? linkedAccountId.value
            : this.linkedAccountId,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BillReminderRow copyWithCompanion(BillRemindersCompanion data) {
    return BillReminderRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      nextDueDate:
          data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      reminderDaysBefore: data.reminderDaysBefore.present
          ? data.reminderDaysBefore.value
          : this.reminderDaysBefore,
      isAutoDetected: data.isAutoDetected.present
          ? data.isAutoDetected.value
          : this.isAutoDetected,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      linkedAccountId: data.linkedAccountId.present
          ? data.linkedAccountId.value
          : this.linkedAccountId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillReminderRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('merchantName: $merchantName, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('frequency: $frequency, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('reminderDaysBefore: $reminderDaysBefore, ')
          ..write('isAutoDetected: $isAutoDetected, ')
          ..write('isActive: $isActive, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      merchantName,
      amountPaisa,
      frequency,
      nextDueDate,
      reminderDaysBefore,
      isAutoDetected,
      isActive,
      linkedAccountId,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillReminderRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.merchantName == this.merchantName &&
          other.amountPaisa == this.amountPaisa &&
          other.frequency == this.frequency &&
          other.nextDueDate == this.nextDueDate &&
          other.reminderDaysBefore == this.reminderDaysBefore &&
          other.isAutoDetected == this.isAutoDetected &&
          other.isActive == this.isActive &&
          other.linkedAccountId == this.linkedAccountId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BillRemindersCompanion extends UpdateCompanion<BillReminderRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> merchantName;
  final Value<int> amountPaisa;
  final Value<BillFrequencyDb> frequency;
  final Value<DateTime> nextDueDate;
  final Value<int> reminderDaysBefore;
  final Value<bool> isAutoDetected;
  final Value<bool> isActive;
  final Value<String?> linkedAccountId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BillRemindersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.frequency = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.reminderDaysBefore = const Value.absent(),
    this.isAutoDetected = const Value.absent(),
    this.isActive = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillRemindersCompanion.insert({
    required String id,
    required String name,
    this.merchantName = const Value.absent(),
    required int amountPaisa,
    required BillFrequencyDb frequency,
    required DateTime nextDueDate,
    this.reminderDaysBefore = const Value.absent(),
    this.isAutoDetected = const Value.absent(),
    this.isActive = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        amountPaisa = Value(amountPaisa),
        frequency = Value(frequency),
        nextDueDate = Value(nextDueDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<BillReminderRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? merchantName,
    Expression<int>? amountPaisa,
    Expression<int>? frequency,
    Expression<DateTime>? nextDueDate,
    Expression<int>? reminderDaysBefore,
    Expression<bool>? isAutoDetected,
    Expression<bool>? isActive,
    Expression<String>? linkedAccountId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (merchantName != null) 'merchant_name': merchantName,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (frequency != null) 'frequency': frequency,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (reminderDaysBefore != null)
        'reminder_days_before': reminderDaysBefore,
      if (isAutoDetected != null) 'is_auto_detected': isAutoDetected,
      if (isActive != null) 'is_active': isActive,
      if (linkedAccountId != null) 'linked_account_id': linkedAccountId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillRemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? merchantName,
      Value<int>? amountPaisa,
      Value<BillFrequencyDb>? frequency,
      Value<DateTime>? nextDueDate,
      Value<int>? reminderDaysBefore,
      Value<bool>? isAutoDetected,
      Value<bool>? isActive,
      Value<String?>? linkedAccountId,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BillRemindersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      merchantName: merchantName ?? this.merchantName,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      frequency: frequency ?? this.frequency,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
      isAutoDetected: isAutoDetected ?? this.isAutoDetected,
      isActive: isActive ?? this.isActive,
      linkedAccountId: linkedAccountId ?? this.linkedAccountId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(
          $BillRemindersTable.$converterfrequency.toSql(frequency.value));
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (reminderDaysBefore.present) {
      map['reminder_days_before'] = Variable<int>(reminderDaysBefore.value);
    }
    if (isAutoDetected.present) {
      map['is_auto_detected'] = Variable<bool>(isAutoDetected.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (linkedAccountId.present) {
      map['linked_account_id'] = Variable<String>(linkedAccountId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillRemindersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('merchantName: $merchantName, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('frequency: $frequency, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('reminderDaysBefore: $reminderDaysBefore, ')
          ..write('isAutoDetected: $isAutoDetected, ')
          ..write('isActive: $isActive, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillPaymentsTable extends BillPayments
    with TableInfo<$BillPaymentsTable, BillPaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<String> billId = GeneratedColumn<String>(
      'bill_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isAutoLinkedMeta =
      const VerificationMeta('isAutoLinked');
  @override
  late final GeneratedColumn<bool> isAutoLinked = GeneratedColumn<bool>(
      'is_auto_linked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_auto_linked" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, billId, amountPaisa, paidAt, transactionId, isAutoLinked];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_payments';
  @override
  VerificationContext validateIntegrity(Insertable<BillPaymentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bill_id')) {
      context.handle(_billIdMeta,
          billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta));
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    if (data.containsKey('is_auto_linked')) {
      context.handle(
          _isAutoLinkedMeta,
          isAutoLinked.isAcceptableOrUnknown(
              data['is_auto_linked']!, _isAutoLinkedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillPaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillPaymentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      billId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_id'])!,
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id']),
      isAutoLinked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_auto_linked'])!,
    );
  }

  @override
  $BillPaymentsTable createAlias(String alias) {
    return $BillPaymentsTable(attachedDatabase, alias);
  }
}

class BillPaymentRow extends DataClass implements Insertable<BillPaymentRow> {
  final String id;
  final String billId;
  final int amountPaisa;
  final DateTime paidAt;
  final String? transactionId;
  final bool isAutoLinked;
  const BillPaymentRow(
      {required this.id,
      required this.billId,
      required this.amountPaisa,
      required this.paidAt,
      this.transactionId,
      required this.isAutoLinked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bill_id'] = Variable<String>(billId);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['paid_at'] = Variable<DateTime>(paidAt);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['is_auto_linked'] = Variable<bool>(isAutoLinked);
    return map;
  }

  BillPaymentsCompanion toCompanion(bool nullToAbsent) {
    return BillPaymentsCompanion(
      id: Value(id),
      billId: Value(billId),
      amountPaisa: Value(amountPaisa),
      paidAt: Value(paidAt),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      isAutoLinked: Value(isAutoLinked),
    );
  }

  factory BillPaymentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillPaymentRow(
      id: serializer.fromJson<String>(json['id']),
      billId: serializer.fromJson<String>(json['billId']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      isAutoLinked: serializer.fromJson<bool>(json['isAutoLinked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'billId': serializer.toJson<String>(billId),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'transactionId': serializer.toJson<String?>(transactionId),
      'isAutoLinked': serializer.toJson<bool>(isAutoLinked),
    };
  }

  BillPaymentRow copyWith(
          {String? id,
          String? billId,
          int? amountPaisa,
          DateTime? paidAt,
          Value<String?> transactionId = const Value.absent(),
          bool? isAutoLinked}) =>
      BillPaymentRow(
        id: id ?? this.id,
        billId: billId ?? this.billId,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        paidAt: paidAt ?? this.paidAt,
        transactionId:
            transactionId.present ? transactionId.value : this.transactionId,
        isAutoLinked: isAutoLinked ?? this.isAutoLinked,
      );
  BillPaymentRow copyWithCompanion(BillPaymentsCompanion data) {
    return BillPaymentRow(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      isAutoLinked: data.isAutoLinked.present
          ? data.isAutoLinked.value
          : this.isAutoLinked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillPaymentRow(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('paidAt: $paidAt, ')
          ..write('transactionId: $transactionId, ')
          ..write('isAutoLinked: $isAutoLinked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, billId, amountPaisa, paidAt, transactionId, isAutoLinked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillPaymentRow &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.amountPaisa == this.amountPaisa &&
          other.paidAt == this.paidAt &&
          other.transactionId == this.transactionId &&
          other.isAutoLinked == this.isAutoLinked);
}

class BillPaymentsCompanion extends UpdateCompanion<BillPaymentRow> {
  final Value<String> id;
  final Value<String> billId;
  final Value<int> amountPaisa;
  final Value<DateTime> paidAt;
  final Value<String?> transactionId;
  final Value<bool> isAutoLinked;
  final Value<int> rowid;
  const BillPaymentsCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.isAutoLinked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillPaymentsCompanion.insert({
    required String id,
    required String billId,
    required int amountPaisa,
    required DateTime paidAt,
    this.transactionId = const Value.absent(),
    this.isAutoLinked = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        billId = Value(billId),
        amountPaisa = Value(amountPaisa),
        paidAt = Value(paidAt);
  static Insertable<BillPaymentRow> custom({
    Expression<String>? id,
    Expression<String>? billId,
    Expression<int>? amountPaisa,
    Expression<DateTime>? paidAt,
    Expression<String>? transactionId,
    Expression<bool>? isAutoLinked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (paidAt != null) 'paid_at': paidAt,
      if (transactionId != null) 'transaction_id': transactionId,
      if (isAutoLinked != null) 'is_auto_linked': isAutoLinked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? billId,
      Value<int>? amountPaisa,
      Value<DateTime>? paidAt,
      Value<String?>? transactionId,
      Value<bool>? isAutoLinked,
      Value<int>? rowid}) {
    return BillPaymentsCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      paidAt: paidAt ?? this.paidAt,
      transactionId: transactionId ?? this.transactionId,
      isAutoLinked: isAutoLinked ?? this.isAutoLinked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<String>(billId.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (isAutoLinked.present) {
      map['is_auto_linked'] = Variable<bool>(isAutoLinked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('paidAt: $paidAt, ')
          ..write('transactionId: $transactionId, ')
          ..write('isAutoLinked: $isAutoLinked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoansTable extends Loans with TableInfo<$LoansTable, LoanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<LoanTypeDb, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<LoanTypeDb>($LoansTable.$convertertype);
  static const VerificationMeta _principalPaisaMeta =
      const VerificationMeta('principalPaisa');
  @override
  late final GeneratedColumn<int> principalPaisa = GeneratedColumn<int>(
      'principal_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _outstandingPaisaMeta =
      const VerificationMeta('outstandingPaisa');
  @override
  late final GeneratedColumn<int> outstandingPaisa = GeneratedColumn<int>(
      'outstanding_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _interestRatePercentMeta =
      const VerificationMeta('interestRatePercent');
  @override
  late final GeneratedColumn<double> interestRatePercent =
      GeneratedColumn<double>('interest_rate_percent', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _emiPaisaMeta =
      const VerificationMeta('emiPaisa');
  @override
  late final GeneratedColumn<int> emiPaisa = GeneratedColumn<int>(
      'emi_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tenureMonthsMeta =
      const VerificationMeta('tenureMonths');
  @override
  late final GeneratedColumn<int> tenureMonths = GeneratedColumn<int>(
      'tenure_months', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalPaidPaisaMeta =
      const VerificationMeta('totalPaidPaisa');
  @override
  late final GeneratedColumn<int> totalPaidPaisa = GeneratedColumn<int>(
      'total_paid_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _nextDueDateMeta =
      const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
      'next_due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastPaymentDateMeta =
      const VerificationMeta('lastPaymentDate');
  @override
  late final GeneratedColumn<DateTime> lastPaymentDate =
      GeneratedColumn<DateTime>('last_payment_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lenderNameMeta =
      const VerificationMeta('lenderName');
  @override
  late final GeneratedColumn<String> lenderName = GeneratedColumn<String>(
      'lender_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        principalPaisa,
        outstandingPaisa,
        interestRatePercent,
        emiPaisa,
        tenureMonths,
        totalPaidPaisa,
        startDate,
        nextDueDate,
        lastPaymentDate,
        lenderName,
        isActive,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(Insertable<LoanRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('principal_paisa')) {
      context.handle(
          _principalPaisaMeta,
          principalPaisa.isAcceptableOrUnknown(
              data['principal_paisa']!, _principalPaisaMeta));
    } else if (isInserting) {
      context.missing(_principalPaisaMeta);
    }
    if (data.containsKey('outstanding_paisa')) {
      context.handle(
          _outstandingPaisaMeta,
          outstandingPaisa.isAcceptableOrUnknown(
              data['outstanding_paisa']!, _outstandingPaisaMeta));
    } else if (isInserting) {
      context.missing(_outstandingPaisaMeta);
    }
    if (data.containsKey('interest_rate_percent')) {
      context.handle(
          _interestRatePercentMeta,
          interestRatePercent.isAcceptableOrUnknown(
              data['interest_rate_percent']!, _interestRatePercentMeta));
    } else if (isInserting) {
      context.missing(_interestRatePercentMeta);
    }
    if (data.containsKey('emi_paisa')) {
      context.handle(_emiPaisaMeta,
          emiPaisa.isAcceptableOrUnknown(data['emi_paisa']!, _emiPaisaMeta));
    } else if (isInserting) {
      context.missing(_emiPaisaMeta);
    }
    if (data.containsKey('tenure_months')) {
      context.handle(
          _tenureMonthsMeta,
          tenureMonths.isAcceptableOrUnknown(
              data['tenure_months']!, _tenureMonthsMeta));
    } else if (isInserting) {
      context.missing(_tenureMonthsMeta);
    }
    if (data.containsKey('total_paid_paisa')) {
      context.handle(
          _totalPaidPaisaMeta,
          totalPaidPaisa.isAcceptableOrUnknown(
              data['total_paid_paisa']!, _totalPaidPaisaMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
          _nextDueDateMeta,
          nextDueDate.isAcceptableOrUnknown(
              data['next_due_date']!, _nextDueDateMeta));
    }
    if (data.containsKey('last_payment_date')) {
      context.handle(
          _lastPaymentDateMeta,
          lastPaymentDate.isAcceptableOrUnknown(
              data['last_payment_date']!, _lastPaymentDateMeta));
    }
    if (data.containsKey('lender_name')) {
      context.handle(
          _lenderNameMeta,
          lenderName.isAcceptableOrUnknown(
              data['lender_name']!, _lenderNameMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $LoansTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      principalPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}principal_paisa'])!,
      outstandingPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}outstanding_paisa'])!,
      interestRatePercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}interest_rate_percent'])!,
      emiPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}emi_paisa'])!,
      tenureMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenure_months'])!,
      totalPaidPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_paid_paisa'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      nextDueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_due_date']),
      lastPaymentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_payment_date']),
      lenderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lender_name']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LoanTypeDb, int, int> $convertertype =
      const EnumIndexConverter<LoanTypeDb>(LoanTypeDb.values);
}

class LoanRow extends DataClass implements Insertable<LoanRow> {
  final String id;
  final String name;
  final LoanTypeDb type;
  final int principalPaisa;
  final int outstandingPaisa;
  final double interestRatePercent;
  final int emiPaisa;
  final int tenureMonths;
  final int totalPaidPaisa;
  final DateTime startDate;
  final DateTime? nextDueDate;
  final DateTime? lastPaymentDate;
  final String? lenderName;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LoanRow(
      {required this.id,
      required this.name,
      required this.type,
      required this.principalPaisa,
      required this.outstandingPaisa,
      required this.interestRatePercent,
      required this.emiPaisa,
      required this.tenureMonths,
      required this.totalPaidPaisa,
      required this.startDate,
      this.nextDueDate,
      this.lastPaymentDate,
      this.lenderName,
      required this.isActive,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>($LoansTable.$convertertype.toSql(type));
    }
    map['principal_paisa'] = Variable<int>(principalPaisa);
    map['outstanding_paisa'] = Variable<int>(outstandingPaisa);
    map['interest_rate_percent'] = Variable<double>(interestRatePercent);
    map['emi_paisa'] = Variable<int>(emiPaisa);
    map['tenure_months'] = Variable<int>(tenureMonths);
    map['total_paid_paisa'] = Variable<int>(totalPaidPaisa);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || nextDueDate != null) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate);
    }
    if (!nullToAbsent || lastPaymentDate != null) {
      map['last_payment_date'] = Variable<DateTime>(lastPaymentDate);
    }
    if (!nullToAbsent || lenderName != null) {
      map['lender_name'] = Variable<String>(lenderName);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      principalPaisa: Value(principalPaisa),
      outstandingPaisa: Value(outstandingPaisa),
      interestRatePercent: Value(interestRatePercent),
      emiPaisa: Value(emiPaisa),
      tenureMonths: Value(tenureMonths),
      totalPaidPaisa: Value(totalPaidPaisa),
      startDate: Value(startDate),
      nextDueDate: nextDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueDate),
      lastPaymentDate: lastPaymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPaymentDate),
      lenderName: lenderName == null && nullToAbsent
          ? const Value.absent()
          : Value(lenderName),
      isActive: Value(isActive),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LoanRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $LoansTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      principalPaisa: serializer.fromJson<int>(json['principalPaisa']),
      outstandingPaisa: serializer.fromJson<int>(json['outstandingPaisa']),
      interestRatePercent:
          serializer.fromJson<double>(json['interestRatePercent']),
      emiPaisa: serializer.fromJson<int>(json['emiPaisa']),
      tenureMonths: serializer.fromJson<int>(json['tenureMonths']),
      totalPaidPaisa: serializer.fromJson<int>(json['totalPaidPaisa']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextDueDate: serializer.fromJson<DateTime?>(json['nextDueDate']),
      lastPaymentDate: serializer.fromJson<DateTime?>(json['lastPaymentDate']),
      lenderName: serializer.fromJson<String?>(json['lenderName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>($LoansTable.$convertertype.toJson(type)),
      'principalPaisa': serializer.toJson<int>(principalPaisa),
      'outstandingPaisa': serializer.toJson<int>(outstandingPaisa),
      'interestRatePercent': serializer.toJson<double>(interestRatePercent),
      'emiPaisa': serializer.toJson<int>(emiPaisa),
      'tenureMonths': serializer.toJson<int>(tenureMonths),
      'totalPaidPaisa': serializer.toJson<int>(totalPaidPaisa),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextDueDate': serializer.toJson<DateTime?>(nextDueDate),
      'lastPaymentDate': serializer.toJson<DateTime?>(lastPaymentDate),
      'lenderName': serializer.toJson<String?>(lenderName),
      'isActive': serializer.toJson<bool>(isActive),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LoanRow copyWith(
          {String? id,
          String? name,
          LoanTypeDb? type,
          int? principalPaisa,
          int? outstandingPaisa,
          double? interestRatePercent,
          int? emiPaisa,
          int? tenureMonths,
          int? totalPaidPaisa,
          DateTime? startDate,
          Value<DateTime?> nextDueDate = const Value.absent(),
          Value<DateTime?> lastPaymentDate = const Value.absent(),
          Value<String?> lenderName = const Value.absent(),
          bool? isActive,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      LoanRow(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        principalPaisa: principalPaisa ?? this.principalPaisa,
        outstandingPaisa: outstandingPaisa ?? this.outstandingPaisa,
        interestRatePercent: interestRatePercent ?? this.interestRatePercent,
        emiPaisa: emiPaisa ?? this.emiPaisa,
        tenureMonths: tenureMonths ?? this.tenureMonths,
        totalPaidPaisa: totalPaidPaisa ?? this.totalPaidPaisa,
        startDate: startDate ?? this.startDate,
        nextDueDate: nextDueDate.present ? nextDueDate.value : this.nextDueDate,
        lastPaymentDate: lastPaymentDate.present
            ? lastPaymentDate.value
            : this.lastPaymentDate,
        lenderName: lenderName.present ? lenderName.value : this.lenderName,
        isActive: isActive ?? this.isActive,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LoanRow copyWithCompanion(LoansCompanion data) {
    return LoanRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      principalPaisa: data.principalPaisa.present
          ? data.principalPaisa.value
          : this.principalPaisa,
      outstandingPaisa: data.outstandingPaisa.present
          ? data.outstandingPaisa.value
          : this.outstandingPaisa,
      interestRatePercent: data.interestRatePercent.present
          ? data.interestRatePercent.value
          : this.interestRatePercent,
      emiPaisa: data.emiPaisa.present ? data.emiPaisa.value : this.emiPaisa,
      tenureMonths: data.tenureMonths.present
          ? data.tenureMonths.value
          : this.tenureMonths,
      totalPaidPaisa: data.totalPaidPaisa.present
          ? data.totalPaidPaisa.value
          : this.totalPaidPaisa,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextDueDate:
          data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      lastPaymentDate: data.lastPaymentDate.present
          ? data.lastPaymentDate.value
          : this.lastPaymentDate,
      lenderName:
          data.lenderName.present ? data.lenderName.value : this.lenderName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('principalPaisa: $principalPaisa, ')
          ..write('outstandingPaisa: $outstandingPaisa, ')
          ..write('interestRatePercent: $interestRatePercent, ')
          ..write('emiPaisa: $emiPaisa, ')
          ..write('tenureMonths: $tenureMonths, ')
          ..write('totalPaidPaisa: $totalPaidPaisa, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('lastPaymentDate: $lastPaymentDate, ')
          ..write('lenderName: $lenderName, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      type,
      principalPaisa,
      outstandingPaisa,
      interestRatePercent,
      emiPaisa,
      tenureMonths,
      totalPaidPaisa,
      startDate,
      nextDueDate,
      lastPaymentDate,
      lenderName,
      isActive,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.principalPaisa == this.principalPaisa &&
          other.outstandingPaisa == this.outstandingPaisa &&
          other.interestRatePercent == this.interestRatePercent &&
          other.emiPaisa == this.emiPaisa &&
          other.tenureMonths == this.tenureMonths &&
          other.totalPaidPaisa == this.totalPaidPaisa &&
          other.startDate == this.startDate &&
          other.nextDueDate == this.nextDueDate &&
          other.lastPaymentDate == this.lastPaymentDate &&
          other.lenderName == this.lenderName &&
          other.isActive == this.isActive &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LoansCompanion extends UpdateCompanion<LoanRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<LoanTypeDb> type;
  final Value<int> principalPaisa;
  final Value<int> outstandingPaisa;
  final Value<double> interestRatePercent;
  final Value<int> emiPaisa;
  final Value<int> tenureMonths;
  final Value<int> totalPaidPaisa;
  final Value<DateTime> startDate;
  final Value<DateTime?> nextDueDate;
  final Value<DateTime?> lastPaymentDate;
  final Value<String?> lenderName;
  final Value<bool> isActive;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.principalPaisa = const Value.absent(),
    this.outstandingPaisa = const Value.absent(),
    this.interestRatePercent = const Value.absent(),
    this.emiPaisa = const Value.absent(),
    this.tenureMonths = const Value.absent(),
    this.totalPaidPaisa = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.lastPaymentDate = const Value.absent(),
    this.lenderName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoansCompanion.insert({
    required String id,
    required String name,
    required LoanTypeDb type,
    required int principalPaisa,
    required int outstandingPaisa,
    required double interestRatePercent,
    required int emiPaisa,
    required int tenureMonths,
    this.totalPaidPaisa = const Value.absent(),
    required DateTime startDate,
    this.nextDueDate = const Value.absent(),
    this.lastPaymentDate = const Value.absent(),
    this.lenderName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        principalPaisa = Value(principalPaisa),
        outstandingPaisa = Value(outstandingPaisa),
        interestRatePercent = Value(interestRatePercent),
        emiPaisa = Value(emiPaisa),
        tenureMonths = Value(tenureMonths),
        startDate = Value(startDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<LoanRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<int>? principalPaisa,
    Expression<int>? outstandingPaisa,
    Expression<double>? interestRatePercent,
    Expression<int>? emiPaisa,
    Expression<int>? tenureMonths,
    Expression<int>? totalPaidPaisa,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextDueDate,
    Expression<DateTime>? lastPaymentDate,
    Expression<String>? lenderName,
    Expression<bool>? isActive,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (principalPaisa != null) 'principal_paisa': principalPaisa,
      if (outstandingPaisa != null) 'outstanding_paisa': outstandingPaisa,
      if (interestRatePercent != null)
        'interest_rate_percent': interestRatePercent,
      if (emiPaisa != null) 'emi_paisa': emiPaisa,
      if (tenureMonths != null) 'tenure_months': tenureMonths,
      if (totalPaidPaisa != null) 'total_paid_paisa': totalPaidPaisa,
      if (startDate != null) 'start_date': startDate,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (lastPaymentDate != null) 'last_payment_date': lastPaymentDate,
      if (lenderName != null) 'lender_name': lenderName,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoansCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<LoanTypeDb>? type,
      Value<int>? principalPaisa,
      Value<int>? outstandingPaisa,
      Value<double>? interestRatePercent,
      Value<int>? emiPaisa,
      Value<int>? tenureMonths,
      Value<int>? totalPaidPaisa,
      Value<DateTime>? startDate,
      Value<DateTime?>? nextDueDate,
      Value<DateTime?>? lastPaymentDate,
      Value<String?>? lenderName,
      Value<bool>? isActive,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LoansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      principalPaisa: principalPaisa ?? this.principalPaisa,
      outstandingPaisa: outstandingPaisa ?? this.outstandingPaisa,
      interestRatePercent: interestRatePercent ?? this.interestRatePercent,
      emiPaisa: emiPaisa ?? this.emiPaisa,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      totalPaidPaisa: totalPaidPaisa ?? this.totalPaidPaisa,
      startDate: startDate ?? this.startDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      lenderName: lenderName ?? this.lenderName,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>($LoansTable.$convertertype.toSql(type.value));
    }
    if (principalPaisa.present) {
      map['principal_paisa'] = Variable<int>(principalPaisa.value);
    }
    if (outstandingPaisa.present) {
      map['outstanding_paisa'] = Variable<int>(outstandingPaisa.value);
    }
    if (interestRatePercent.present) {
      map['interest_rate_percent'] =
          Variable<double>(interestRatePercent.value);
    }
    if (emiPaisa.present) {
      map['emi_paisa'] = Variable<int>(emiPaisa.value);
    }
    if (tenureMonths.present) {
      map['tenure_months'] = Variable<int>(tenureMonths.value);
    }
    if (totalPaidPaisa.present) {
      map['total_paid_paisa'] = Variable<int>(totalPaidPaisa.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (lastPaymentDate.present) {
      map['last_payment_date'] = Variable<DateTime>(lastPaymentDate.value);
    }
    if (lenderName.present) {
      map['lender_name'] = Variable<String>(lenderName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('principalPaisa: $principalPaisa, ')
          ..write('outstandingPaisa: $outstandingPaisa, ')
          ..write('interestRatePercent: $interestRatePercent, ')
          ..write('emiPaisa: $emiPaisa, ')
          ..write('tenureMonths: $tenureMonths, ')
          ..write('totalPaidPaisa: $totalPaidPaisa, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('lastPaymentDate: $lastPaymentDate, ')
          ..write('lenderName: $lenderName, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoanPaymentsTable extends LoanPayments
    with TableInfo<$LoanPaymentsTable, LoanPaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<String> loanId = GeneratedColumn<String>(
      'loan_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _principalPaidPaisaMeta =
      const VerificationMeta('principalPaidPaisa');
  @override
  late final GeneratedColumn<int> principalPaidPaisa = GeneratedColumn<int>(
      'principal_paid_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _interestPaidPaisaMeta =
      const VerificationMeta('interestPaidPaisa');
  @override
  late final GeneratedColumn<int> interestPaidPaisa = GeneratedColumn<int>(
      'interest_paid_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isExtraPaymentMeta =
      const VerificationMeta('isExtraPayment');
  @override
  late final GeneratedColumn<bool> isExtraPayment = GeneratedColumn<bool>(
      'is_extra_payment', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_extra_payment" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        loanId,
        amountPaisa,
        principalPaidPaisa,
        interestPaidPaisa,
        paidAt,
        isExtraPayment,
        transactionId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_payments';
  @override
  VerificationContext validateIntegrity(Insertable<LoanPaymentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('loan_id')) {
      context.handle(_loanIdMeta,
          loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta));
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('principal_paid_paisa')) {
      context.handle(
          _principalPaidPaisaMeta,
          principalPaidPaisa.isAcceptableOrUnknown(
              data['principal_paid_paisa']!, _principalPaidPaisaMeta));
    } else if (isInserting) {
      context.missing(_principalPaidPaisaMeta);
    }
    if (data.containsKey('interest_paid_paisa')) {
      context.handle(
          _interestPaidPaisaMeta,
          interestPaidPaisa.isAcceptableOrUnknown(
              data['interest_paid_paisa']!, _interestPaidPaisaMeta));
    } else if (isInserting) {
      context.missing(_interestPaidPaisaMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('is_extra_payment')) {
      context.handle(
          _isExtraPaymentMeta,
          isExtraPayment.isAcceptableOrUnknown(
              data['is_extra_payment']!, _isExtraPaymentMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanPaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanPaymentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      loanId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}loan_id'])!,
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      principalPaidPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}principal_paid_paisa'])!,
      interestPaidPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}interest_paid_paisa'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at'])!,
      isExtraPayment: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_extra_payment'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id']),
    );
  }

  @override
  $LoanPaymentsTable createAlias(String alias) {
    return $LoanPaymentsTable(attachedDatabase, alias);
  }
}

class LoanPaymentRow extends DataClass implements Insertable<LoanPaymentRow> {
  final String id;
  final String loanId;
  final int amountPaisa;
  final int principalPaidPaisa;
  final int interestPaidPaisa;
  final DateTime paidAt;
  final bool isExtraPayment;
  final String? transactionId;
  const LoanPaymentRow(
      {required this.id,
      required this.loanId,
      required this.amountPaisa,
      required this.principalPaidPaisa,
      required this.interestPaidPaisa,
      required this.paidAt,
      required this.isExtraPayment,
      this.transactionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['loan_id'] = Variable<String>(loanId);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['principal_paid_paisa'] = Variable<int>(principalPaidPaisa);
    map['interest_paid_paisa'] = Variable<int>(interestPaidPaisa);
    map['paid_at'] = Variable<DateTime>(paidAt);
    map['is_extra_payment'] = Variable<bool>(isExtraPayment);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    return map;
  }

  LoanPaymentsCompanion toCompanion(bool nullToAbsent) {
    return LoanPaymentsCompanion(
      id: Value(id),
      loanId: Value(loanId),
      amountPaisa: Value(amountPaisa),
      principalPaidPaisa: Value(principalPaidPaisa),
      interestPaidPaisa: Value(interestPaidPaisa),
      paidAt: Value(paidAt),
      isExtraPayment: Value(isExtraPayment),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
    );
  }

  factory LoanPaymentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanPaymentRow(
      id: serializer.fromJson<String>(json['id']),
      loanId: serializer.fromJson<String>(json['loanId']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      principalPaidPaisa: serializer.fromJson<int>(json['principalPaidPaisa']),
      interestPaidPaisa: serializer.fromJson<int>(json['interestPaidPaisa']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      isExtraPayment: serializer.fromJson<bool>(json['isExtraPayment']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'loanId': serializer.toJson<String>(loanId),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'principalPaidPaisa': serializer.toJson<int>(principalPaidPaisa),
      'interestPaidPaisa': serializer.toJson<int>(interestPaidPaisa),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'isExtraPayment': serializer.toJson<bool>(isExtraPayment),
      'transactionId': serializer.toJson<String?>(transactionId),
    };
  }

  LoanPaymentRow copyWith(
          {String? id,
          String? loanId,
          int? amountPaisa,
          int? principalPaidPaisa,
          int? interestPaidPaisa,
          DateTime? paidAt,
          bool? isExtraPayment,
          Value<String?> transactionId = const Value.absent()}) =>
      LoanPaymentRow(
        id: id ?? this.id,
        loanId: loanId ?? this.loanId,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        principalPaidPaisa: principalPaidPaisa ?? this.principalPaidPaisa,
        interestPaidPaisa: interestPaidPaisa ?? this.interestPaidPaisa,
        paidAt: paidAt ?? this.paidAt,
        isExtraPayment: isExtraPayment ?? this.isExtraPayment,
        transactionId:
            transactionId.present ? transactionId.value : this.transactionId,
      );
  LoanPaymentRow copyWithCompanion(LoanPaymentsCompanion data) {
    return LoanPaymentRow(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      principalPaidPaisa: data.principalPaidPaisa.present
          ? data.principalPaidPaisa.value
          : this.principalPaidPaisa,
      interestPaidPaisa: data.interestPaidPaisa.present
          ? data.interestPaidPaisa.value
          : this.interestPaidPaisa,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      isExtraPayment: data.isExtraPayment.present
          ? data.isExtraPayment.value
          : this.isExtraPayment,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanPaymentRow(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('principalPaidPaisa: $principalPaidPaisa, ')
          ..write('interestPaidPaisa: $interestPaidPaisa, ')
          ..write('paidAt: $paidAt, ')
          ..write('isExtraPayment: $isExtraPayment, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, loanId, amountPaisa, principalPaidPaisa,
      interestPaidPaisa, paidAt, isExtraPayment, transactionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanPaymentRow &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.amountPaisa == this.amountPaisa &&
          other.principalPaidPaisa == this.principalPaidPaisa &&
          other.interestPaidPaisa == this.interestPaidPaisa &&
          other.paidAt == this.paidAt &&
          other.isExtraPayment == this.isExtraPayment &&
          other.transactionId == this.transactionId);
}

class LoanPaymentsCompanion extends UpdateCompanion<LoanPaymentRow> {
  final Value<String> id;
  final Value<String> loanId;
  final Value<int> amountPaisa;
  final Value<int> principalPaidPaisa;
  final Value<int> interestPaidPaisa;
  final Value<DateTime> paidAt;
  final Value<bool> isExtraPayment;
  final Value<String?> transactionId;
  final Value<int> rowid;
  const LoanPaymentsCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.principalPaidPaisa = const Value.absent(),
    this.interestPaidPaisa = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.isExtraPayment = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoanPaymentsCompanion.insert({
    required String id,
    required String loanId,
    required int amountPaisa,
    required int principalPaidPaisa,
    required int interestPaidPaisa,
    required DateTime paidAt,
    this.isExtraPayment = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        loanId = Value(loanId),
        amountPaisa = Value(amountPaisa),
        principalPaidPaisa = Value(principalPaidPaisa),
        interestPaidPaisa = Value(interestPaidPaisa),
        paidAt = Value(paidAt);
  static Insertable<LoanPaymentRow> custom({
    Expression<String>? id,
    Expression<String>? loanId,
    Expression<int>? amountPaisa,
    Expression<int>? principalPaidPaisa,
    Expression<int>? interestPaidPaisa,
    Expression<DateTime>? paidAt,
    Expression<bool>? isExtraPayment,
    Expression<String>? transactionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (principalPaidPaisa != null)
        'principal_paid_paisa': principalPaidPaisa,
      if (interestPaidPaisa != null) 'interest_paid_paisa': interestPaidPaisa,
      if (paidAt != null) 'paid_at': paidAt,
      if (isExtraPayment != null) 'is_extra_payment': isExtraPayment,
      if (transactionId != null) 'transaction_id': transactionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoanPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? loanId,
      Value<int>? amountPaisa,
      Value<int>? principalPaidPaisa,
      Value<int>? interestPaidPaisa,
      Value<DateTime>? paidAt,
      Value<bool>? isExtraPayment,
      Value<String?>? transactionId,
      Value<int>? rowid}) {
    return LoanPaymentsCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      principalPaidPaisa: principalPaidPaisa ?? this.principalPaidPaisa,
      interestPaidPaisa: interestPaidPaisa ?? this.interestPaidPaisa,
      paidAt: paidAt ?? this.paidAt,
      isExtraPayment: isExtraPayment ?? this.isExtraPayment,
      transactionId: transactionId ?? this.transactionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<String>(loanId.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (principalPaidPaisa.present) {
      map['principal_paid_paisa'] = Variable<int>(principalPaidPaisa.value);
    }
    if (interestPaidPaisa.present) {
      map['interest_paid_paisa'] = Variable<int>(interestPaidPaisa.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (isExtraPayment.present) {
      map['is_extra_payment'] = Variable<bool>(isExtraPayment.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('principalPaidPaisa: $principalPaidPaisa, ')
          ..write('interestPaidPaisa: $interestPaidPaisa, ')
          ..write('paidAt: $paidAt, ')
          ..write('isExtraPayment: $isExtraPayment, ')
          ..write('transactionId: $transactionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditCardsTable extends CreditCards
    with TableInfo<$CreditCardsTable, CreditCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastFourDigitsMeta =
      const VerificationMeta('lastFourDigits');
  @override
  late final GeneratedColumn<String> lastFourDigits = GeneratedColumn<String>(
      'last_four_digits', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creditLimitPaisaMeta =
      const VerificationMeta('creditLimitPaisa');
  @override
  late final GeneratedColumn<int> creditLimitPaisa = GeneratedColumn<int>(
      'credit_limit_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentOutstandingPaisaMeta =
      const VerificationMeta('currentOutstandingPaisa');
  @override
  late final GeneratedColumn<int> currentOutstandingPaisa =
      GeneratedColumn<int>('current_outstanding_paisa', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
      'due_day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statementDayMeta =
      const VerificationMeta('statementDay');
  @override
  late final GeneratedColumn<int> statementDay = GeneratedColumn<int>(
      'statement_day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _interestRatePercentMeta =
      const VerificationMeta('interestRatePercent');
  @override
  late final GeneratedColumn<double> interestRatePercent =
      GeneratedColumn<double>('interest_rate_percent', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _bankNameMeta =
      const VerificationMeta('bankName');
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
      'bank_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        lastFourDigits,
        creditLimitPaisa,
        currentOutstandingPaisa,
        dueDay,
        statementDay,
        interestRatePercent,
        bankName,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_cards';
  @override
  VerificationContext validateIntegrity(Insertable<CreditCardRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_four_digits')) {
      context.handle(
          _lastFourDigitsMeta,
          lastFourDigits.isAcceptableOrUnknown(
              data['last_four_digits']!, _lastFourDigitsMeta));
    } else if (isInserting) {
      context.missing(_lastFourDigitsMeta);
    }
    if (data.containsKey('credit_limit_paisa')) {
      context.handle(
          _creditLimitPaisaMeta,
          creditLimitPaisa.isAcceptableOrUnknown(
              data['credit_limit_paisa']!, _creditLimitPaisaMeta));
    } else if (isInserting) {
      context.missing(_creditLimitPaisaMeta);
    }
    if (data.containsKey('current_outstanding_paisa')) {
      context.handle(
          _currentOutstandingPaisaMeta,
          currentOutstandingPaisa.isAcceptableOrUnknown(
              data['current_outstanding_paisa']!,
              _currentOutstandingPaisaMeta));
    }
    if (data.containsKey('due_day')) {
      context.handle(_dueDayMeta,
          dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta));
    } else if (isInserting) {
      context.missing(_dueDayMeta);
    }
    if (data.containsKey('statement_day')) {
      context.handle(
          _statementDayMeta,
          statementDay.isAcceptableOrUnknown(
              data['statement_day']!, _statementDayMeta));
    } else if (isInserting) {
      context.missing(_statementDayMeta);
    }
    if (data.containsKey('interest_rate_percent')) {
      context.handle(
          _interestRatePercentMeta,
          interestRatePercent.isAcceptableOrUnknown(
              data['interest_rate_percent']!, _interestRatePercentMeta));
    } else if (isInserting) {
      context.missing(_interestRatePercentMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(_bankNameMeta,
          bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCardRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      lastFourDigits: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_four_digits'])!,
      creditLimitPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}credit_limit_paisa'])!,
      currentOutstandingPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}current_outstanding_paisa'])!,
      dueDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_day'])!,
      statementDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}statement_day'])!,
      interestRatePercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}interest_rate_percent'])!,
      bankName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_name']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CreditCardsTable createAlias(String alias) {
    return $CreditCardsTable(attachedDatabase, alias);
  }
}

class CreditCardRow extends DataClass implements Insertable<CreditCardRow> {
  final String id;
  final String name;
  final String lastFourDigits;
  final int creditLimitPaisa;
  final int currentOutstandingPaisa;
  final int dueDay;
  final int statementDay;
  final double interestRatePercent;
  final String? bankName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CreditCardRow(
      {required this.id,
      required this.name,
      required this.lastFourDigits,
      required this.creditLimitPaisa,
      required this.currentOutstandingPaisa,
      required this.dueDay,
      required this.statementDay,
      required this.interestRatePercent,
      this.bankName,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['last_four_digits'] = Variable<String>(lastFourDigits);
    map['credit_limit_paisa'] = Variable<int>(creditLimitPaisa);
    map['current_outstanding_paisa'] = Variable<int>(currentOutstandingPaisa);
    map['due_day'] = Variable<int>(dueDay);
    map['statement_day'] = Variable<int>(statementDay);
    map['interest_rate_percent'] = Variable<double>(interestRatePercent);
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CreditCardsCompanion toCompanion(bool nullToAbsent) {
    return CreditCardsCompanion(
      id: Value(id),
      name: Value(name),
      lastFourDigits: Value(lastFourDigits),
      creditLimitPaisa: Value(creditLimitPaisa),
      currentOutstandingPaisa: Value(currentOutstandingPaisa),
      dueDay: Value(dueDay),
      statementDay: Value(statementDay),
      interestRatePercent: Value(interestRatePercent),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CreditCardRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCardRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lastFourDigits: serializer.fromJson<String>(json['lastFourDigits']),
      creditLimitPaisa: serializer.fromJson<int>(json['creditLimitPaisa']),
      currentOutstandingPaisa:
          serializer.fromJson<int>(json['currentOutstandingPaisa']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      statementDay: serializer.fromJson<int>(json['statementDay']),
      interestRatePercent:
          serializer.fromJson<double>(json['interestRatePercent']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'lastFourDigits': serializer.toJson<String>(lastFourDigits),
      'creditLimitPaisa': serializer.toJson<int>(creditLimitPaisa),
      'currentOutstandingPaisa':
          serializer.toJson<int>(currentOutstandingPaisa),
      'dueDay': serializer.toJson<int>(dueDay),
      'statementDay': serializer.toJson<int>(statementDay),
      'interestRatePercent': serializer.toJson<double>(interestRatePercent),
      'bankName': serializer.toJson<String?>(bankName),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CreditCardRow copyWith(
          {String? id,
          String? name,
          String? lastFourDigits,
          int? creditLimitPaisa,
          int? currentOutstandingPaisa,
          int? dueDay,
          int? statementDay,
          double? interestRatePercent,
          Value<String?> bankName = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CreditCardRow(
        id: id ?? this.id,
        name: name ?? this.name,
        lastFourDigits: lastFourDigits ?? this.lastFourDigits,
        creditLimitPaisa: creditLimitPaisa ?? this.creditLimitPaisa,
        currentOutstandingPaisa:
            currentOutstandingPaisa ?? this.currentOutstandingPaisa,
        dueDay: dueDay ?? this.dueDay,
        statementDay: statementDay ?? this.statementDay,
        interestRatePercent: interestRatePercent ?? this.interestRatePercent,
        bankName: bankName.present ? bankName.value : this.bankName,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CreditCardRow copyWithCompanion(CreditCardsCompanion data) {
    return CreditCardRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lastFourDigits: data.lastFourDigits.present
          ? data.lastFourDigits.value
          : this.lastFourDigits,
      creditLimitPaisa: data.creditLimitPaisa.present
          ? data.creditLimitPaisa.value
          : this.creditLimitPaisa,
      currentOutstandingPaisa: data.currentOutstandingPaisa.present
          ? data.currentOutstandingPaisa.value
          : this.currentOutstandingPaisa,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      statementDay: data.statementDay.present
          ? data.statementDay.value
          : this.statementDay,
      interestRatePercent: data.interestRatePercent.present
          ? data.interestRatePercent.value
          : this.interestRatePercent,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastFourDigits: $lastFourDigits, ')
          ..write('creditLimitPaisa: $creditLimitPaisa, ')
          ..write('currentOutstandingPaisa: $currentOutstandingPaisa, ')
          ..write('dueDay: $dueDay, ')
          ..write('statementDay: $statementDay, ')
          ..write('interestRatePercent: $interestRatePercent, ')
          ..write('bankName: $bankName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      lastFourDigits,
      creditLimitPaisa,
      currentOutstandingPaisa,
      dueDay,
      statementDay,
      interestRatePercent,
      bankName,
      isActive,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCardRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.lastFourDigits == this.lastFourDigits &&
          other.creditLimitPaisa == this.creditLimitPaisa &&
          other.currentOutstandingPaisa == this.currentOutstandingPaisa &&
          other.dueDay == this.dueDay &&
          other.statementDay == this.statementDay &&
          other.interestRatePercent == this.interestRatePercent &&
          other.bankName == this.bankName &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CreditCardsCompanion extends UpdateCompanion<CreditCardRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> lastFourDigits;
  final Value<int> creditLimitPaisa;
  final Value<int> currentOutstandingPaisa;
  final Value<int> dueDay;
  final Value<int> statementDay;
  final Value<double> interestRatePercent;
  final Value<String?> bankName;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CreditCardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lastFourDigits = const Value.absent(),
    this.creditLimitPaisa = const Value.absent(),
    this.currentOutstandingPaisa = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.statementDay = const Value.absent(),
    this.interestRatePercent = const Value.absent(),
    this.bankName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditCardsCompanion.insert({
    required String id,
    required String name,
    required String lastFourDigits,
    required int creditLimitPaisa,
    this.currentOutstandingPaisa = const Value.absent(),
    required int dueDay,
    required int statementDay,
    required double interestRatePercent,
    this.bankName = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        lastFourDigits = Value(lastFourDigits),
        creditLimitPaisa = Value(creditLimitPaisa),
        dueDay = Value(dueDay),
        statementDay = Value(statementDay),
        interestRatePercent = Value(interestRatePercent),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CreditCardRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? lastFourDigits,
    Expression<int>? creditLimitPaisa,
    Expression<int>? currentOutstandingPaisa,
    Expression<int>? dueDay,
    Expression<int>? statementDay,
    Expression<double>? interestRatePercent,
    Expression<String>? bankName,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lastFourDigits != null) 'last_four_digits': lastFourDigits,
      if (creditLimitPaisa != null) 'credit_limit_paisa': creditLimitPaisa,
      if (currentOutstandingPaisa != null)
        'current_outstanding_paisa': currentOutstandingPaisa,
      if (dueDay != null) 'due_day': dueDay,
      if (statementDay != null) 'statement_day': statementDay,
      if (interestRatePercent != null)
        'interest_rate_percent': interestRatePercent,
      if (bankName != null) 'bank_name': bankName,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditCardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? lastFourDigits,
      Value<int>? creditLimitPaisa,
      Value<int>? currentOutstandingPaisa,
      Value<int>? dueDay,
      Value<int>? statementDay,
      Value<double>? interestRatePercent,
      Value<String?>? bankName,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CreditCardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      creditLimitPaisa: creditLimitPaisa ?? this.creditLimitPaisa,
      currentOutstandingPaisa:
          currentOutstandingPaisa ?? this.currentOutstandingPaisa,
      dueDay: dueDay ?? this.dueDay,
      statementDay: statementDay ?? this.statementDay,
      interestRatePercent: interestRatePercent ?? this.interestRatePercent,
      bankName: bankName ?? this.bankName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastFourDigits.present) {
      map['last_four_digits'] = Variable<String>(lastFourDigits.value);
    }
    if (creditLimitPaisa.present) {
      map['credit_limit_paisa'] = Variable<int>(creditLimitPaisa.value);
    }
    if (currentOutstandingPaisa.present) {
      map['current_outstanding_paisa'] =
          Variable<int>(currentOutstandingPaisa.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (statementDay.present) {
      map['statement_day'] = Variable<int>(statementDay.value);
    }
    if (interestRatePercent.present) {
      map['interest_rate_percent'] =
          Variable<double>(interestRatePercent.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastFourDigits: $lastFourDigits, ')
          ..write('creditLimitPaisa: $creditLimitPaisa, ')
          ..write('currentOutstandingPaisa: $currentOutstandingPaisa, ')
          ..write('dueDay: $dueDay, ')
          ..write('statementDay: $statementDay, ')
          ..write('interestRatePercent: $interestRatePercent, ')
          ..write('bankName: $bankName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvestmentsTable extends Investments
    with TableInfo<$InvestmentsTable, InvestmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<InvestmentTypeDb, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<InvestmentTypeDb>($InvestmentsTable.$convertertype);
  static const VerificationMeta _platformIdMeta =
      const VerificationMeta('platformId');
  @override
  late final GeneratedColumn<String> platformId = GeneratedColumn<String>(
      'platform_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _investedPaisaMeta =
      const VerificationMeta('investedPaisa');
  @override
  late final GeneratedColumn<int> investedPaisa = GeneratedColumn<int>(
      'invested_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentValuePaisaMeta =
      const VerificationMeta('currentValuePaisa');
  @override
  late final GeneratedColumn<int> currentValuePaisa = GeneratedColumn<int>(
      'current_value_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<double> units = GeneratedColumn<double>(
      'units', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _avgBuyPriceMeta =
      const VerificationMeta('avgBuyPrice');
  @override
  late final GeneratedColumn<double> avgBuyPrice = GeneratedColumn<double>(
      'avg_buy_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _maturityDateMeta =
      const VerificationMeta('maturityDate');
  @override
  late final GeneratedColumn<DateTime> maturityDate = GeneratedColumn<DateTime>(
      'maturity_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _interestRateMeta =
      const VerificationMeta('interestRate');
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
      'interest_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isinMeta = const VerificationMeta('isin');
  @override
  late final GeneratedColumn<String> isin = GeneratedColumn<String>(
      'isin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSipMeta = const VerificationMeta('isSip');
  @override
  late final GeneratedColumn<bool> isSip = GeneratedColumn<bool>(
      'is_sip', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_sip" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sipAmountPaisaMeta =
      const VerificationMeta('sipAmountPaisa');
  @override
  late final GeneratedColumn<int> sipAmountPaisa = GeneratedColumn<int>(
      'sip_amount_paisa', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sipDayMeta = const VerificationMeta('sipDay');
  @override
  late final GeneratedColumn<int> sipDay = GeneratedColumn<int>(
      'sip_day', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        platformId,
        investedPaisa,
        currentValuePaisa,
        units,
        avgBuyPrice,
        startDate,
        maturityDate,
        interestRate,
        symbol,
        isin,
        isSip,
        sipAmountPaisa,
        sipDay,
        lastUpdated,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investments';
  @override
  VerificationContext validateIntegrity(Insertable<InvestmentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('platform_id')) {
      context.handle(
          _platformIdMeta,
          platformId.isAcceptableOrUnknown(
              data['platform_id']!, _platformIdMeta));
    }
    if (data.containsKey('invested_paisa')) {
      context.handle(
          _investedPaisaMeta,
          investedPaisa.isAcceptableOrUnknown(
              data['invested_paisa']!, _investedPaisaMeta));
    } else if (isInserting) {
      context.missing(_investedPaisaMeta);
    }
    if (data.containsKey('current_value_paisa')) {
      context.handle(
          _currentValuePaisaMeta,
          currentValuePaisa.isAcceptableOrUnknown(
              data['current_value_paisa']!, _currentValuePaisaMeta));
    } else if (isInserting) {
      context.missing(_currentValuePaisaMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
          _unitsMeta, units.isAcceptableOrUnknown(data['units']!, _unitsMeta));
    }
    if (data.containsKey('avg_buy_price')) {
      context.handle(
          _avgBuyPriceMeta,
          avgBuyPrice.isAcceptableOrUnknown(
              data['avg_buy_price']!, _avgBuyPriceMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('maturity_date')) {
      context.handle(
          _maturityDateMeta,
          maturityDate.isAcceptableOrUnknown(
              data['maturity_date']!, _maturityDateMeta));
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
          _interestRateMeta,
          interestRate.isAcceptableOrUnknown(
              data['interest_rate']!, _interestRateMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    }
    if (data.containsKey('isin')) {
      context.handle(
          _isinMeta, isin.isAcceptableOrUnknown(data['isin']!, _isinMeta));
    }
    if (data.containsKey('is_sip')) {
      context.handle(
          _isSipMeta, isSip.isAcceptableOrUnknown(data['is_sip']!, _isSipMeta));
    }
    if (data.containsKey('sip_amount_paisa')) {
      context.handle(
          _sipAmountPaisaMeta,
          sipAmountPaisa.isAcceptableOrUnknown(
              data['sip_amount_paisa']!, _sipAmountPaisaMeta));
    }
    if (data.containsKey('sip_day')) {
      context.handle(_sipDayMeta,
          sipDay.isAcceptableOrUnknown(data['sip_day']!, _sipDayMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvestmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $InvestmentsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      platformId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}platform_id']),
      investedPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invested_paisa'])!,
      currentValuePaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}current_value_paisa'])!,
      units: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}units'])!,
      avgBuyPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_buy_price']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      maturityDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}maturity_date']),
      interestRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}interest_rate']),
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol']),
      isin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}isin']),
      isSip: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_sip'])!,
      sipAmountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sip_amount_paisa']),
      sipDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sip_day']),
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InvestmentsTable createAlias(String alias) {
    return $InvestmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InvestmentTypeDb, int, int> $convertertype =
      const EnumIndexConverter<InvestmentTypeDb>(InvestmentTypeDb.values);
}

class InvestmentRow extends DataClass implements Insertable<InvestmentRow> {
  final String id;
  final String name;
  final InvestmentTypeDb type;
  final String? platformId;
  final int investedPaisa;
  final int currentValuePaisa;
  final double units;
  final double? avgBuyPrice;
  final DateTime startDate;
  final DateTime? maturityDate;
  final double? interestRate;
  final String? symbol;
  final String? isin;
  final bool isSip;
  final int? sipAmountPaisa;
  final int? sipDay;
  final DateTime lastUpdated;
  final String? notes;
  final DateTime createdAt;
  const InvestmentRow(
      {required this.id,
      required this.name,
      required this.type,
      this.platformId,
      required this.investedPaisa,
      required this.currentValuePaisa,
      required this.units,
      this.avgBuyPrice,
      required this.startDate,
      this.maturityDate,
      this.interestRate,
      this.symbol,
      this.isin,
      required this.isSip,
      this.sipAmountPaisa,
      this.sipDay,
      required this.lastUpdated,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>($InvestmentsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || platformId != null) {
      map['platform_id'] = Variable<String>(platformId);
    }
    map['invested_paisa'] = Variable<int>(investedPaisa);
    map['current_value_paisa'] = Variable<int>(currentValuePaisa);
    map['units'] = Variable<double>(units);
    if (!nullToAbsent || avgBuyPrice != null) {
      map['avg_buy_price'] = Variable<double>(avgBuyPrice);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || maturityDate != null) {
      map['maturity_date'] = Variable<DateTime>(maturityDate);
    }
    if (!nullToAbsent || interestRate != null) {
      map['interest_rate'] = Variable<double>(interestRate);
    }
    if (!nullToAbsent || symbol != null) {
      map['symbol'] = Variable<String>(symbol);
    }
    if (!nullToAbsent || isin != null) {
      map['isin'] = Variable<String>(isin);
    }
    map['is_sip'] = Variable<bool>(isSip);
    if (!nullToAbsent || sipAmountPaisa != null) {
      map['sip_amount_paisa'] = Variable<int>(sipAmountPaisa);
    }
    if (!nullToAbsent || sipDay != null) {
      map['sip_day'] = Variable<int>(sipDay);
    }
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvestmentsCompanion toCompanion(bool nullToAbsent) {
    return InvestmentsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      platformId: platformId == null && nullToAbsent
          ? const Value.absent()
          : Value(platformId),
      investedPaisa: Value(investedPaisa),
      currentValuePaisa: Value(currentValuePaisa),
      units: Value(units),
      avgBuyPrice: avgBuyPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(avgBuyPrice),
      startDate: Value(startDate),
      maturityDate: maturityDate == null && nullToAbsent
          ? const Value.absent()
          : Value(maturityDate),
      interestRate: interestRate == null && nullToAbsent
          ? const Value.absent()
          : Value(interestRate),
      symbol:
          symbol == null && nullToAbsent ? const Value.absent() : Value(symbol),
      isin: isin == null && nullToAbsent ? const Value.absent() : Value(isin),
      isSip: Value(isSip),
      sipAmountPaisa: sipAmountPaisa == null && nullToAbsent
          ? const Value.absent()
          : Value(sipAmountPaisa),
      sipDay:
          sipDay == null && nullToAbsent ? const Value.absent() : Value(sipDay),
      lastUpdated: Value(lastUpdated),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory InvestmentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $InvestmentsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      platformId: serializer.fromJson<String?>(json['platformId']),
      investedPaisa: serializer.fromJson<int>(json['investedPaisa']),
      currentValuePaisa: serializer.fromJson<int>(json['currentValuePaisa']),
      units: serializer.fromJson<double>(json['units']),
      avgBuyPrice: serializer.fromJson<double?>(json['avgBuyPrice']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      maturityDate: serializer.fromJson<DateTime?>(json['maturityDate']),
      interestRate: serializer.fromJson<double?>(json['interestRate']),
      symbol: serializer.fromJson<String?>(json['symbol']),
      isin: serializer.fromJson<String?>(json['isin']),
      isSip: serializer.fromJson<bool>(json['isSip']),
      sipAmountPaisa: serializer.fromJson<int?>(json['sipAmountPaisa']),
      sipDay: serializer.fromJson<int?>(json['sipDay']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type':
          serializer.toJson<int>($InvestmentsTable.$convertertype.toJson(type)),
      'platformId': serializer.toJson<String?>(platformId),
      'investedPaisa': serializer.toJson<int>(investedPaisa),
      'currentValuePaisa': serializer.toJson<int>(currentValuePaisa),
      'units': serializer.toJson<double>(units),
      'avgBuyPrice': serializer.toJson<double?>(avgBuyPrice),
      'startDate': serializer.toJson<DateTime>(startDate),
      'maturityDate': serializer.toJson<DateTime?>(maturityDate),
      'interestRate': serializer.toJson<double?>(interestRate),
      'symbol': serializer.toJson<String?>(symbol),
      'isin': serializer.toJson<String?>(isin),
      'isSip': serializer.toJson<bool>(isSip),
      'sipAmountPaisa': serializer.toJson<int?>(sipAmountPaisa),
      'sipDay': serializer.toJson<int?>(sipDay),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InvestmentRow copyWith(
          {String? id,
          String? name,
          InvestmentTypeDb? type,
          Value<String?> platformId = const Value.absent(),
          int? investedPaisa,
          int? currentValuePaisa,
          double? units,
          Value<double?> avgBuyPrice = const Value.absent(),
          DateTime? startDate,
          Value<DateTime?> maturityDate = const Value.absent(),
          Value<double?> interestRate = const Value.absent(),
          Value<String?> symbol = const Value.absent(),
          Value<String?> isin = const Value.absent(),
          bool? isSip,
          Value<int?> sipAmountPaisa = const Value.absent(),
          Value<int?> sipDay = const Value.absent(),
          DateTime? lastUpdated,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      InvestmentRow(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        platformId: platformId.present ? platformId.value : this.platformId,
        investedPaisa: investedPaisa ?? this.investedPaisa,
        currentValuePaisa: currentValuePaisa ?? this.currentValuePaisa,
        units: units ?? this.units,
        avgBuyPrice: avgBuyPrice.present ? avgBuyPrice.value : this.avgBuyPrice,
        startDate: startDate ?? this.startDate,
        maturityDate:
            maturityDate.present ? maturityDate.value : this.maturityDate,
        interestRate:
            interestRate.present ? interestRate.value : this.interestRate,
        symbol: symbol.present ? symbol.value : this.symbol,
        isin: isin.present ? isin.value : this.isin,
        isSip: isSip ?? this.isSip,
        sipAmountPaisa:
            sipAmountPaisa.present ? sipAmountPaisa.value : this.sipAmountPaisa,
        sipDay: sipDay.present ? sipDay.value : this.sipDay,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  InvestmentRow copyWithCompanion(InvestmentsCompanion data) {
    return InvestmentRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      platformId:
          data.platformId.present ? data.platformId.value : this.platformId,
      investedPaisa: data.investedPaisa.present
          ? data.investedPaisa.value
          : this.investedPaisa,
      currentValuePaisa: data.currentValuePaisa.present
          ? data.currentValuePaisa.value
          : this.currentValuePaisa,
      units: data.units.present ? data.units.value : this.units,
      avgBuyPrice:
          data.avgBuyPrice.present ? data.avgBuyPrice.value : this.avgBuyPrice,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      maturityDate: data.maturityDate.present
          ? data.maturityDate.value
          : this.maturityDate,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      isin: data.isin.present ? data.isin.value : this.isin,
      isSip: data.isSip.present ? data.isSip.value : this.isSip,
      sipAmountPaisa: data.sipAmountPaisa.present
          ? data.sipAmountPaisa.value
          : this.sipAmountPaisa,
      sipDay: data.sipDay.present ? data.sipDay.value : this.sipDay,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('platformId: $platformId, ')
          ..write('investedPaisa: $investedPaisa, ')
          ..write('currentValuePaisa: $currentValuePaisa, ')
          ..write('units: $units, ')
          ..write('avgBuyPrice: $avgBuyPrice, ')
          ..write('startDate: $startDate, ')
          ..write('maturityDate: $maturityDate, ')
          ..write('interestRate: $interestRate, ')
          ..write('symbol: $symbol, ')
          ..write('isin: $isin, ')
          ..write('isSip: $isSip, ')
          ..write('sipAmountPaisa: $sipAmountPaisa, ')
          ..write('sipDay: $sipDay, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      type,
      platformId,
      investedPaisa,
      currentValuePaisa,
      units,
      avgBuyPrice,
      startDate,
      maturityDate,
      interestRate,
      symbol,
      isin,
      isSip,
      sipAmountPaisa,
      sipDay,
      lastUpdated,
      notes,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestmentRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.platformId == this.platformId &&
          other.investedPaisa == this.investedPaisa &&
          other.currentValuePaisa == this.currentValuePaisa &&
          other.units == this.units &&
          other.avgBuyPrice == this.avgBuyPrice &&
          other.startDate == this.startDate &&
          other.maturityDate == this.maturityDate &&
          other.interestRate == this.interestRate &&
          other.symbol == this.symbol &&
          other.isin == this.isin &&
          other.isSip == this.isSip &&
          other.sipAmountPaisa == this.sipAmountPaisa &&
          other.sipDay == this.sipDay &&
          other.lastUpdated == this.lastUpdated &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class InvestmentsCompanion extends UpdateCompanion<InvestmentRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<InvestmentTypeDb> type;
  final Value<String?> platformId;
  final Value<int> investedPaisa;
  final Value<int> currentValuePaisa;
  final Value<double> units;
  final Value<double?> avgBuyPrice;
  final Value<DateTime> startDate;
  final Value<DateTime?> maturityDate;
  final Value<double?> interestRate;
  final Value<String?> symbol;
  final Value<String?> isin;
  final Value<bool> isSip;
  final Value<int?> sipAmountPaisa;
  final Value<int?> sipDay;
  final Value<DateTime> lastUpdated;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InvestmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.platformId = const Value.absent(),
    this.investedPaisa = const Value.absent(),
    this.currentValuePaisa = const Value.absent(),
    this.units = const Value.absent(),
    this.avgBuyPrice = const Value.absent(),
    this.startDate = const Value.absent(),
    this.maturityDate = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.symbol = const Value.absent(),
    this.isin = const Value.absent(),
    this.isSip = const Value.absent(),
    this.sipAmountPaisa = const Value.absent(),
    this.sipDay = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentsCompanion.insert({
    required String id,
    required String name,
    required InvestmentTypeDb type,
    this.platformId = const Value.absent(),
    required int investedPaisa,
    required int currentValuePaisa,
    this.units = const Value.absent(),
    this.avgBuyPrice = const Value.absent(),
    required DateTime startDate,
    this.maturityDate = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.symbol = const Value.absent(),
    this.isin = const Value.absent(),
    this.isSip = const Value.absent(),
    this.sipAmountPaisa = const Value.absent(),
    this.sipDay = const Value.absent(),
    required DateTime lastUpdated,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        investedPaisa = Value(investedPaisa),
        currentValuePaisa = Value(currentValuePaisa),
        startDate = Value(startDate),
        lastUpdated = Value(lastUpdated),
        createdAt = Value(createdAt);
  static Insertable<InvestmentRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? platformId,
    Expression<int>? investedPaisa,
    Expression<int>? currentValuePaisa,
    Expression<double>? units,
    Expression<double>? avgBuyPrice,
    Expression<DateTime>? startDate,
    Expression<DateTime>? maturityDate,
    Expression<double>? interestRate,
    Expression<String>? symbol,
    Expression<String>? isin,
    Expression<bool>? isSip,
    Expression<int>? sipAmountPaisa,
    Expression<int>? sipDay,
    Expression<DateTime>? lastUpdated,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (platformId != null) 'platform_id': platformId,
      if (investedPaisa != null) 'invested_paisa': investedPaisa,
      if (currentValuePaisa != null) 'current_value_paisa': currentValuePaisa,
      if (units != null) 'units': units,
      if (avgBuyPrice != null) 'avg_buy_price': avgBuyPrice,
      if (startDate != null) 'start_date': startDate,
      if (maturityDate != null) 'maturity_date': maturityDate,
      if (interestRate != null) 'interest_rate': interestRate,
      if (symbol != null) 'symbol': symbol,
      if (isin != null) 'isin': isin,
      if (isSip != null) 'is_sip': isSip,
      if (sipAmountPaisa != null) 'sip_amount_paisa': sipAmountPaisa,
      if (sipDay != null) 'sip_day': sipDay,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<InvestmentTypeDb>? type,
      Value<String?>? platformId,
      Value<int>? investedPaisa,
      Value<int>? currentValuePaisa,
      Value<double>? units,
      Value<double?>? avgBuyPrice,
      Value<DateTime>? startDate,
      Value<DateTime?>? maturityDate,
      Value<double?>? interestRate,
      Value<String?>? symbol,
      Value<String?>? isin,
      Value<bool>? isSip,
      Value<int?>? sipAmountPaisa,
      Value<int?>? sipDay,
      Value<DateTime>? lastUpdated,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return InvestmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      platformId: platformId ?? this.platformId,
      investedPaisa: investedPaisa ?? this.investedPaisa,
      currentValuePaisa: currentValuePaisa ?? this.currentValuePaisa,
      units: units ?? this.units,
      avgBuyPrice: avgBuyPrice ?? this.avgBuyPrice,
      startDate: startDate ?? this.startDate,
      maturityDate: maturityDate ?? this.maturityDate,
      interestRate: interestRate ?? this.interestRate,
      symbol: symbol ?? this.symbol,
      isin: isin ?? this.isin,
      isSip: isSip ?? this.isSip,
      sipAmountPaisa: sipAmountPaisa ?? this.sipAmountPaisa,
      sipDay: sipDay ?? this.sipDay,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($InvestmentsTable.$convertertype.toSql(type.value));
    }
    if (platformId.present) {
      map['platform_id'] = Variable<String>(platformId.value);
    }
    if (investedPaisa.present) {
      map['invested_paisa'] = Variable<int>(investedPaisa.value);
    }
    if (currentValuePaisa.present) {
      map['current_value_paisa'] = Variable<int>(currentValuePaisa.value);
    }
    if (units.present) {
      map['units'] = Variable<double>(units.value);
    }
    if (avgBuyPrice.present) {
      map['avg_buy_price'] = Variable<double>(avgBuyPrice.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (maturityDate.present) {
      map['maturity_date'] = Variable<DateTime>(maturityDate.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (isin.present) {
      map['isin'] = Variable<String>(isin.value);
    }
    if (isSip.present) {
      map['is_sip'] = Variable<bool>(isSip.value);
    }
    if (sipAmountPaisa.present) {
      map['sip_amount_paisa'] = Variable<int>(sipAmountPaisa.value);
    }
    if (sipDay.present) {
      map['sip_day'] = Variable<int>(sipDay.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('platformId: $platformId, ')
          ..write('investedPaisa: $investedPaisa, ')
          ..write('currentValuePaisa: $currentValuePaisa, ')
          ..write('units: $units, ')
          ..write('avgBuyPrice: $avgBuyPrice, ')
          ..write('startDate: $startDate, ')
          ..write('maturityDate: $maturityDate, ')
          ..write('interestRate: $interestRate, ')
          ..write('symbol: $symbol, ')
          ..write('isin: $isin, ')
          ..write('isSip: $isSip, ')
          ..write('sipAmountPaisa: $sipAmountPaisa, ')
          ..write('sipDay: $sipDay, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvestmentTransactionsTable extends InvestmentTransactions
    with TableInfo<$InvestmentTransactionsTable, InvestmentTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _investmentIdMeta =
      const VerificationMeta('investmentId');
  @override
  late final GeneratedColumn<String> investmentId = GeneratedColumn<String>(
      'investment_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<InvestmentTransactionTypeDb, int>
      type = GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<InvestmentTransactionTypeDb>(
              $InvestmentTransactionsTable.$convertertype);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<double> units = GeneratedColumn<double>(
      'units', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pricePerUnitMeta =
      const VerificationMeta('pricePerUnit');
  @override
  late final GeneratedColumn<double> pricePerUnit = GeneratedColumn<double>(
      'price_per_unit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        investmentId,
        type,
        amountPaisa,
        units,
        pricePerUnit,
        transactionDate,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investment_transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<InvestmentTransactionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('investment_id')) {
      context.handle(
          _investmentIdMeta,
          investmentId.isAcceptableOrUnknown(
              data['investment_id']!, _investmentIdMeta));
    } else if (isInserting) {
      context.missing(_investmentIdMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
          _unitsMeta, units.isAcceptableOrUnknown(data['units']!, _unitsMeta));
    } else if (isInserting) {
      context.missing(_unitsMeta);
    }
    if (data.containsKey('price_per_unit')) {
      context.handle(
          _pricePerUnitMeta,
          pricePerUnit.isAcceptableOrUnknown(
              data['price_per_unit']!, _pricePerUnitMeta));
    } else if (isInserting) {
      context.missing(_pricePerUnitMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvestmentTransactionRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentTransactionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      investmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}investment_id'])!,
      type: $InvestmentTransactionsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      units: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}units'])!,
      pricePerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_per_unit'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $InvestmentTransactionsTable createAlias(String alias) {
    return $InvestmentTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InvestmentTransactionTypeDb, int, int>
      $convertertype = const EnumIndexConverter<InvestmentTransactionTypeDb>(
          InvestmentTransactionTypeDb.values);
}

class InvestmentTransactionRow extends DataClass
    implements Insertable<InvestmentTransactionRow> {
  final String id;
  final String investmentId;
  final InvestmentTransactionTypeDb type;
  final int amountPaisa;
  final double units;
  final double pricePerUnit;
  final DateTime transactionDate;
  final String? notes;
  const InvestmentTransactionRow(
      {required this.id,
      required this.investmentId,
      required this.type,
      required this.amountPaisa,
      required this.units,
      required this.pricePerUnit,
      required this.transactionDate,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['investment_id'] = Variable<String>(investmentId);
    {
      map['type'] = Variable<int>(
          $InvestmentTransactionsTable.$convertertype.toSql(type));
    }
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['units'] = Variable<double>(units);
    map['price_per_unit'] = Variable<double>(pricePerUnit);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  InvestmentTransactionsCompanion toCompanion(bool nullToAbsent) {
    return InvestmentTransactionsCompanion(
      id: Value(id),
      investmentId: Value(investmentId),
      type: Value(type),
      amountPaisa: Value(amountPaisa),
      units: Value(units),
      pricePerUnit: Value(pricePerUnit),
      transactionDate: Value(transactionDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory InvestmentTransactionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentTransactionRow(
      id: serializer.fromJson<String>(json['id']),
      investmentId: serializer.fromJson<String>(json['investmentId']),
      type: $InvestmentTransactionsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      units: serializer.fromJson<double>(json['units']),
      pricePerUnit: serializer.fromJson<double>(json['pricePerUnit']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'investmentId': serializer.toJson<String>(investmentId),
      'type': serializer.toJson<int>(
          $InvestmentTransactionsTable.$convertertype.toJson(type)),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'units': serializer.toJson<double>(units),
      'pricePerUnit': serializer.toJson<double>(pricePerUnit),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  InvestmentTransactionRow copyWith(
          {String? id,
          String? investmentId,
          InvestmentTransactionTypeDb? type,
          int? amountPaisa,
          double? units,
          double? pricePerUnit,
          DateTime? transactionDate,
          Value<String?> notes = const Value.absent()}) =>
      InvestmentTransactionRow(
        id: id ?? this.id,
        investmentId: investmentId ?? this.investmentId,
        type: type ?? this.type,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        units: units ?? this.units,
        pricePerUnit: pricePerUnit ?? this.pricePerUnit,
        transactionDate: transactionDate ?? this.transactionDate,
        notes: notes.present ? notes.value : this.notes,
      );
  InvestmentTransactionRow copyWithCompanion(
      InvestmentTransactionsCompanion data) {
    return InvestmentTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      investmentId: data.investmentId.present
          ? data.investmentId.value
          : this.investmentId,
      type: data.type.present ? data.type.value : this.type,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      units: data.units.present ? data.units.value : this.units,
      pricePerUnit: data.pricePerUnit.present
          ? data.pricePerUnit.value
          : this.pricePerUnit,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentTransactionRow(')
          ..write('id: $id, ')
          ..write('investmentId: $investmentId, ')
          ..write('type: $type, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('units: $units, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, investmentId, type, amountPaisa, units,
      pricePerUnit, transactionDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestmentTransactionRow &&
          other.id == this.id &&
          other.investmentId == this.investmentId &&
          other.type == this.type &&
          other.amountPaisa == this.amountPaisa &&
          other.units == this.units &&
          other.pricePerUnit == this.pricePerUnit &&
          other.transactionDate == this.transactionDate &&
          other.notes == this.notes);
}

class InvestmentTransactionsCompanion
    extends UpdateCompanion<InvestmentTransactionRow> {
  final Value<String> id;
  final Value<String> investmentId;
  final Value<InvestmentTransactionTypeDb> type;
  final Value<int> amountPaisa;
  final Value<double> units;
  final Value<double> pricePerUnit;
  final Value<DateTime> transactionDate;
  final Value<String?> notes;
  final Value<int> rowid;
  const InvestmentTransactionsCompanion({
    this.id = const Value.absent(),
    this.investmentId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.units = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentTransactionsCompanion.insert({
    required String id,
    required String investmentId,
    required InvestmentTransactionTypeDb type,
    required int amountPaisa,
    required double units,
    required double pricePerUnit,
    required DateTime transactionDate,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        investmentId = Value(investmentId),
        type = Value(type),
        amountPaisa = Value(amountPaisa),
        units = Value(units),
        pricePerUnit = Value(pricePerUnit),
        transactionDate = Value(transactionDate);
  static Insertable<InvestmentTransactionRow> custom({
    Expression<String>? id,
    Expression<String>? investmentId,
    Expression<int>? type,
    Expression<int>? amountPaisa,
    Expression<double>? units,
    Expression<double>? pricePerUnit,
    Expression<DateTime>? transactionDate,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (investmentId != null) 'investment_id': investmentId,
      if (type != null) 'type': type,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (units != null) 'units': units,
      if (pricePerUnit != null) 'price_per_unit': pricePerUnit,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentTransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? investmentId,
      Value<InvestmentTransactionTypeDb>? type,
      Value<int>? amountPaisa,
      Value<double>? units,
      Value<double>? pricePerUnit,
      Value<DateTime>? transactionDate,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return InvestmentTransactionsCompanion(
      id: id ?? this.id,
      investmentId: investmentId ?? this.investmentId,
      type: type ?? this.type,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      units: units ?? this.units,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      transactionDate: transactionDate ?? this.transactionDate,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (investmentId.present) {
      map['investment_id'] = Variable<String>(investmentId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
          $InvestmentTransactionsTable.$convertertype.toSql(type.value));
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (units.present) {
      map['units'] = Variable<double>(units.value);
    }
    if (pricePerUnit.present) {
      map['price_per_unit'] = Variable<double>(pricePerUnit.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('investmentId: $investmentId, ')
          ..write('type: $type, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('units: $units, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FriendsTable extends Friends with TableInfo<$FriendsTable, FriendRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalOwedPaisaMeta =
      const VerificationMeta('totalOwedPaisa');
  @override
  late final GeneratedColumn<int> totalOwedPaisa = GeneratedColumn<int>(
      'total_owed_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalOwingPaisaMeta =
      const VerificationMeta('totalOwingPaisa');
  @override
  late final GeneratedColumn<int> totalOwingPaisa = GeneratedColumn<int>(
      'total_owing_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastActivityAtMeta =
      const VerificationMeta('lastActivityAt');
  @override
  late final GeneratedColumn<DateTime> lastActivityAt =
      GeneratedColumn<DateTime>('last_activity_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        email,
        avatarUrl,
        totalOwedPaisa,
        totalOwingPaisa,
        lastActivityAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friends';
  @override
  VerificationContext validateIntegrity(Insertable<FriendRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('total_owed_paisa')) {
      context.handle(
          _totalOwedPaisaMeta,
          totalOwedPaisa.isAcceptableOrUnknown(
              data['total_owed_paisa']!, _totalOwedPaisaMeta));
    }
    if (data.containsKey('total_owing_paisa')) {
      context.handle(
          _totalOwingPaisaMeta,
          totalOwingPaisa.isAcceptableOrUnknown(
              data['total_owing_paisa']!, _totalOwingPaisaMeta));
    }
    if (data.containsKey('last_activity_at')) {
      context.handle(
          _lastActivityAtMeta,
          lastActivityAt.isAcceptableOrUnknown(
              data['last_activity_at']!, _lastActivityAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FriendRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FriendRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      totalOwedPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_owed_paisa'])!,
      totalOwingPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_owing_paisa'])!,
      lastActivityAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_activity_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FriendsTable createAlias(String alias) {
    return $FriendsTable(attachedDatabase, alias);
  }
}

class FriendRow extends DataClass implements Insertable<FriendRow> {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? avatarUrl;
  final int totalOwedPaisa;
  final int totalOwingPaisa;
  final DateTime? lastActivityAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FriendRow(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.avatarUrl,
      required this.totalOwedPaisa,
      required this.totalOwingPaisa,
      this.lastActivityAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['total_owed_paisa'] = Variable<int>(totalOwedPaisa);
    map['total_owing_paisa'] = Variable<int>(totalOwingPaisa);
    if (!nullToAbsent || lastActivityAt != null) {
      map['last_activity_at'] = Variable<DateTime>(lastActivityAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FriendsCompanion toCompanion(bool nullToAbsent) {
    return FriendsCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      totalOwedPaisa: Value(totalOwedPaisa),
      totalOwingPaisa: Value(totalOwingPaisa),
      lastActivityAt: lastActivityAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActivityAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FriendRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FriendRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      totalOwedPaisa: serializer.fromJson<int>(json['totalOwedPaisa']),
      totalOwingPaisa: serializer.fromJson<int>(json['totalOwingPaisa']),
      lastActivityAt: serializer.fromJson<DateTime?>(json['lastActivityAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'totalOwedPaisa': serializer.toJson<int>(totalOwedPaisa),
      'totalOwingPaisa': serializer.toJson<int>(totalOwingPaisa),
      'lastActivityAt': serializer.toJson<DateTime?>(lastActivityAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FriendRow copyWith(
          {String? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> avatarUrl = const Value.absent(),
          int? totalOwedPaisa,
          int? totalOwingPaisa,
          Value<DateTime?> lastActivityAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FriendRow(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        totalOwedPaisa: totalOwedPaisa ?? this.totalOwedPaisa,
        totalOwingPaisa: totalOwingPaisa ?? this.totalOwingPaisa,
        lastActivityAt:
            lastActivityAt.present ? lastActivityAt.value : this.lastActivityAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FriendRow copyWithCompanion(FriendsCompanion data) {
    return FriendRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      totalOwedPaisa: data.totalOwedPaisa.present
          ? data.totalOwedPaisa.value
          : this.totalOwedPaisa,
      totalOwingPaisa: data.totalOwingPaisa.present
          ? data.totalOwingPaisa.value
          : this.totalOwingPaisa,
      lastActivityAt: data.lastActivityAt.present
          ? data.lastActivityAt.value
          : this.lastActivityAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FriendRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('totalOwedPaisa: $totalOwedPaisa, ')
          ..write('totalOwingPaisa: $totalOwingPaisa, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, email, avatarUrl,
      totalOwedPaisa, totalOwingPaisa, lastActivityAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FriendRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.avatarUrl == this.avatarUrl &&
          other.totalOwedPaisa == this.totalOwedPaisa &&
          other.totalOwingPaisa == this.totalOwingPaisa &&
          other.lastActivityAt == this.lastActivityAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FriendsCompanion extends UpdateCompanion<FriendRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> avatarUrl;
  final Value<int> totalOwedPaisa;
  final Value<int> totalOwingPaisa;
  final Value<DateTime?> lastActivityAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FriendsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.totalOwedPaisa = const Value.absent(),
    this.totalOwingPaisa = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FriendsCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.totalOwedPaisa = const Value.absent(),
    this.totalOwingPaisa = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<FriendRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? avatarUrl,
    Expression<int>? totalOwedPaisa,
    Expression<int>? totalOwingPaisa,
    Expression<DateTime>? lastActivityAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (totalOwedPaisa != null) 'total_owed_paisa': totalOwedPaisa,
      if (totalOwingPaisa != null) 'total_owing_paisa': totalOwingPaisa,
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FriendsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? avatarUrl,
      Value<int>? totalOwedPaisa,
      Value<int>? totalOwingPaisa,
      Value<DateTime?>? lastActivityAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return FriendsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalOwedPaisa: totalOwedPaisa ?? this.totalOwedPaisa,
      totalOwingPaisa: totalOwingPaisa ?? this.totalOwingPaisa,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (totalOwedPaisa.present) {
      map['total_owed_paisa'] = Variable<int>(totalOwedPaisa.value);
    }
    if (totalOwingPaisa.present) {
      map['total_owing_paisa'] = Variable<int>(totalOwingPaisa.value);
    }
    if (lastActivityAt.present) {
      map['last_activity_at'] = Variable<DateTime>(lastActivityAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('totalOwedPaisa: $totalOwedPaisa, ')
          ..write('totalOwingPaisa: $totalOwingPaisa, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseGroupsTable extends ExpenseGroups
    with TableInfo<$ExpenseGroupsTable, ExpenseGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconCodePointMeta =
      const VerificationMeta('iconCodePoint');
  @override
  late final GeneratedColumn<String> iconCodePoint = GeneratedColumn<String>(
      'icon_code_point', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _memberIdsMeta =
      const VerificationMeta('memberIds');
  @override
  late final GeneratedColumn<String> memberIds = GeneratedColumn<String>(
      'member_ids', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _totalExpensesPaisaMeta =
      const VerificationMeta('totalExpensesPaisa');
  @override
  late final GeneratedColumn<int> totalExpensesPaisa = GeneratedColumn<int>(
      'total_expenses_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastActivityAtMeta =
      const VerificationMeta('lastActivityAt');
  @override
  late final GeneratedColumn<DateTime> lastActivityAt =
      GeneratedColumn<DateTime>('last_activity_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        iconCodePoint,
        colorValue,
        memberIds,
        totalExpensesPaisa,
        lastActivityAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_groups';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseGroupRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
          _iconCodePointMeta,
          iconCodePoint.isAcceptableOrUnknown(
              data['icon_code_point']!, _iconCodePointMeta));
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    if (data.containsKey('member_ids')) {
      context.handle(_memberIdsMeta,
          memberIds.isAcceptableOrUnknown(data['member_ids']!, _memberIdsMeta));
    }
    if (data.containsKey('total_expenses_paisa')) {
      context.handle(
          _totalExpensesPaisaMeta,
          totalExpensesPaisa.isAcceptableOrUnknown(
              data['total_expenses_paisa']!, _totalExpensesPaisaMeta));
    }
    if (data.containsKey('last_activity_at')) {
      context.handle(
          _lastActivityAtMeta,
          lastActivityAt.isAcceptableOrUnknown(
              data['last_activity_at']!, _lastActivityAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseGroupRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      iconCodePoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_code_point']),
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value']),
      memberIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_ids'])!,
      totalExpensesPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_expenses_paisa'])!,
      lastActivityAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_activity_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ExpenseGroupsTable createAlias(String alias) {
    return $ExpenseGroupsTable(attachedDatabase, alias);
  }
}

class ExpenseGroupRow extends DataClass implements Insertable<ExpenseGroupRow> {
  final String id;
  final String name;
  final String? description;
  final String? iconCodePoint;
  final int? colorValue;
  final String memberIds;
  final int totalExpensesPaisa;
  final DateTime? lastActivityAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ExpenseGroupRow(
      {required this.id,
      required this.name,
      this.description,
      this.iconCodePoint,
      this.colorValue,
      required this.memberIds,
      required this.totalExpensesPaisa,
      this.lastActivityAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || iconCodePoint != null) {
      map['icon_code_point'] = Variable<String>(iconCodePoint);
    }
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    map['member_ids'] = Variable<String>(memberIds);
    map['total_expenses_paisa'] = Variable<int>(totalExpensesPaisa);
    if (!nullToAbsent || lastActivityAt != null) {
      map['last_activity_at'] = Variable<DateTime>(lastActivityAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpenseGroupsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseGroupsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      iconCodePoint: iconCodePoint == null && nullToAbsent
          ? const Value.absent()
          : Value(iconCodePoint),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      memberIds: Value(memberIds),
      totalExpensesPaisa: Value(totalExpensesPaisa),
      lastActivityAt: lastActivityAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActivityAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExpenseGroupRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseGroupRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      iconCodePoint: serializer.fromJson<String?>(json['iconCodePoint']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      memberIds: serializer.fromJson<String>(json['memberIds']),
      totalExpensesPaisa: serializer.fromJson<int>(json['totalExpensesPaisa']),
      lastActivityAt: serializer.fromJson<DateTime?>(json['lastActivityAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'iconCodePoint': serializer.toJson<String?>(iconCodePoint),
      'colorValue': serializer.toJson<int?>(colorValue),
      'memberIds': serializer.toJson<String>(memberIds),
      'totalExpensesPaisa': serializer.toJson<int>(totalExpensesPaisa),
      'lastActivityAt': serializer.toJson<DateTime?>(lastActivityAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExpenseGroupRow copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> iconCodePoint = const Value.absent(),
          Value<int?> colorValue = const Value.absent(),
          String? memberIds,
          int? totalExpensesPaisa,
          Value<DateTime?> lastActivityAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ExpenseGroupRow(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        iconCodePoint:
            iconCodePoint.present ? iconCodePoint.value : this.iconCodePoint,
        colorValue: colorValue.present ? colorValue.value : this.colorValue,
        memberIds: memberIds ?? this.memberIds,
        totalExpensesPaisa: totalExpensesPaisa ?? this.totalExpensesPaisa,
        lastActivityAt:
            lastActivityAt.present ? lastActivityAt.value : this.lastActivityAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ExpenseGroupRow copyWithCompanion(ExpenseGroupsCompanion data) {
    return ExpenseGroupRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      memberIds: data.memberIds.present ? data.memberIds.value : this.memberIds,
      totalExpensesPaisa: data.totalExpensesPaisa.present
          ? data.totalExpensesPaisa.value
          : this.totalExpensesPaisa,
      lastActivityAt: data.lastActivityAt.present
          ? data.lastActivityAt.value
          : this.lastActivityAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseGroupRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('colorValue: $colorValue, ')
          ..write('memberIds: $memberIds, ')
          ..write('totalExpensesPaisa: $totalExpensesPaisa, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      iconCodePoint,
      colorValue,
      memberIds,
      totalExpensesPaisa,
      lastActivityAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseGroupRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.iconCodePoint == this.iconCodePoint &&
          other.colorValue == this.colorValue &&
          other.memberIds == this.memberIds &&
          other.totalExpensesPaisa == this.totalExpensesPaisa &&
          other.lastActivityAt == this.lastActivityAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpenseGroupsCompanion extends UpdateCompanion<ExpenseGroupRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> iconCodePoint;
  final Value<int?> colorValue;
  final Value<String> memberIds;
  final Value<int> totalExpensesPaisa;
  final Value<DateTime?> lastActivityAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExpenseGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.memberIds = const Value.absent(),
    this.totalExpensesPaisa = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseGroupsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.memberIds = const Value.absent(),
    this.totalExpensesPaisa = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ExpenseGroupRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? iconCodePoint,
    Expression<int>? colorValue,
    Expression<String>? memberIds,
    Expression<int>? totalExpensesPaisa,
    Expression<DateTime>? lastActivityAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (colorValue != null) 'color_value': colorValue,
      if (memberIds != null) 'member_ids': memberIds,
      if (totalExpensesPaisa != null)
        'total_expenses_paisa': totalExpensesPaisa,
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseGroupsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? iconCodePoint,
      Value<int?>? colorValue,
      Value<String>? memberIds,
      Value<int>? totalExpensesPaisa,
      Value<DateTime?>? lastActivityAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ExpenseGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      memberIds: memberIds ?? this.memberIds,
      totalExpensesPaisa: totalExpensesPaisa ?? this.totalExpensesPaisa,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<String>(iconCodePoint.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (memberIds.present) {
      map['member_ids'] = Variable<String>(memberIds.value);
    }
    if (totalExpensesPaisa.present) {
      map['total_expenses_paisa'] = Variable<int>(totalExpensesPaisa.value);
    }
    if (lastActivityAt.present) {
      map['last_activity_at'] = Variable<DateTime>(lastActivityAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('colorValue: $colorValue, ')
          ..write('memberIds: $memberIds, ')
          ..write('totalExpensesPaisa: $totalExpensesPaisa, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SharedExpensesTable extends SharedExpenses
    with TableInfo<$SharedExpensesTable, SharedExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SharedExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountPaisaMeta =
      const VerificationMeta('totalAmountPaisa');
  @override
  late final GeneratedColumn<int> totalAmountPaisa = GeneratedColumn<int>(
      'total_amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidByIdMeta =
      const VerificationMeta('paidById');
  @override
  late final GeneratedColumn<String> paidById = GeneratedColumn<String>(
      'paid_by_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SplitTypeDb, int> splitType =
      GeneratedColumn<int>('split_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SplitTypeDb>($SharedExpensesTable.$convertersplitType);
  static const VerificationMeta _participantsJsonMeta =
      const VerificationMeta('participantsJson');
  @override
  late final GeneratedColumn<String> participantsJson = GeneratedColumn<String>(
      'participants_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SettlementStatusDb, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SettlementStatusDb>(
              $SharedExpensesTable.$converterstatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expenseDateMeta =
      const VerificationMeta('expenseDate');
  @override
  late final GeneratedColumn<DateTime> expenseDate = GeneratedColumn<DateTime>(
      'expense_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transactionId,
        groupId,
        description,
        totalAmountPaisa,
        paidById,
        splitType,
        participantsJson,
        status,
        notes,
        expenseDate,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shared_expenses';
  @override
  VerificationContext validateIntegrity(Insertable<SharedExpenseRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('total_amount_paisa')) {
      context.handle(
          _totalAmountPaisaMeta,
          totalAmountPaisa.isAcceptableOrUnknown(
              data['total_amount_paisa']!, _totalAmountPaisaMeta));
    } else if (isInserting) {
      context.missing(_totalAmountPaisaMeta);
    }
    if (data.containsKey('paid_by_id')) {
      context.handle(_paidByIdMeta,
          paidById.isAcceptableOrUnknown(data['paid_by_id']!, _paidByIdMeta));
    } else if (isInserting) {
      context.missing(_paidByIdMeta);
    }
    if (data.containsKey('participants_json')) {
      context.handle(
          _participantsJsonMeta,
          participantsJson.isAcceptableOrUnknown(
              data['participants_json']!, _participantsJsonMeta));
    } else if (isInserting) {
      context.missing(_participantsJsonMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('expense_date')) {
      context.handle(
          _expenseDateMeta,
          expenseDate.isAcceptableOrUnknown(
              data['expense_date']!, _expenseDateMeta));
    } else if (isInserting) {
      context.missing(_expenseDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SharedExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SharedExpenseRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      totalAmountPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_amount_paisa'])!,
      paidById: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}paid_by_id'])!,
      splitType: $SharedExpensesTable.$convertersplitType.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}split_type'])!),
      participantsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}participants_json'])!,
      status: $SharedExpensesTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      expenseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expense_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SharedExpensesTable createAlias(String alias) {
    return $SharedExpensesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SplitTypeDb, int, int> $convertersplitType =
      const EnumIndexConverter<SplitTypeDb>(SplitTypeDb.values);
  static JsonTypeConverter2<SettlementStatusDb, int, int> $converterstatus =
      const EnumIndexConverter<SettlementStatusDb>(SettlementStatusDb.values);
}

class SharedExpenseRow extends DataClass
    implements Insertable<SharedExpenseRow> {
  final String id;
  final String? transactionId;
  final String? groupId;
  final String description;
  final int totalAmountPaisa;
  final String paidById;
  final SplitTypeDb splitType;
  final String participantsJson;
  final SettlementStatusDb status;
  final String? notes;
  final DateTime expenseDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SharedExpenseRow(
      {required this.id,
      this.transactionId,
      this.groupId,
      required this.description,
      required this.totalAmountPaisa,
      required this.paidById,
      required this.splitType,
      required this.participantsJson,
      required this.status,
      this.notes,
      required this.expenseDate,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['description'] = Variable<String>(description);
    map['total_amount_paisa'] = Variable<int>(totalAmountPaisa);
    map['paid_by_id'] = Variable<String>(paidById);
    {
      map['split_type'] = Variable<int>(
          $SharedExpensesTable.$convertersplitType.toSql(splitType));
    }
    map['participants_json'] = Variable<String>(participantsJson);
    {
      map['status'] =
          Variable<int>($SharedExpensesTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['expense_date'] = Variable<DateTime>(expenseDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SharedExpensesCompanion toCompanion(bool nullToAbsent) {
    return SharedExpensesCompanion(
      id: Value(id),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      description: Value(description),
      totalAmountPaisa: Value(totalAmountPaisa),
      paidById: Value(paidById),
      splitType: Value(splitType),
      participantsJson: Value(participantsJson),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      expenseDate: Value(expenseDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SharedExpenseRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SharedExpenseRow(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      description: serializer.fromJson<String>(json['description']),
      totalAmountPaisa: serializer.fromJson<int>(json['totalAmountPaisa']),
      paidById: serializer.fromJson<String>(json['paidById']),
      splitType: $SharedExpensesTable.$convertersplitType
          .fromJson(serializer.fromJson<int>(json['splitType'])),
      participantsJson: serializer.fromJson<String>(json['participantsJson']),
      status: $SharedExpensesTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      notes: serializer.fromJson<String?>(json['notes']),
      expenseDate: serializer.fromJson<DateTime>(json['expenseDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String?>(transactionId),
      'groupId': serializer.toJson<String?>(groupId),
      'description': serializer.toJson<String>(description),
      'totalAmountPaisa': serializer.toJson<int>(totalAmountPaisa),
      'paidById': serializer.toJson<String>(paidById),
      'splitType': serializer.toJson<int>(
          $SharedExpensesTable.$convertersplitType.toJson(splitType)),
      'participantsJson': serializer.toJson<String>(participantsJson),
      'status': serializer
          .toJson<int>($SharedExpensesTable.$converterstatus.toJson(status)),
      'notes': serializer.toJson<String?>(notes),
      'expenseDate': serializer.toJson<DateTime>(expenseDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SharedExpenseRow copyWith(
          {String? id,
          Value<String?> transactionId = const Value.absent(),
          Value<String?> groupId = const Value.absent(),
          String? description,
          int? totalAmountPaisa,
          String? paidById,
          SplitTypeDb? splitType,
          String? participantsJson,
          SettlementStatusDb? status,
          Value<String?> notes = const Value.absent(),
          DateTime? expenseDate,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SharedExpenseRow(
        id: id ?? this.id,
        transactionId:
            transactionId.present ? transactionId.value : this.transactionId,
        groupId: groupId.present ? groupId.value : this.groupId,
        description: description ?? this.description,
        totalAmountPaisa: totalAmountPaisa ?? this.totalAmountPaisa,
        paidById: paidById ?? this.paidById,
        splitType: splitType ?? this.splitType,
        participantsJson: participantsJson ?? this.participantsJson,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        expenseDate: expenseDate ?? this.expenseDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SharedExpenseRow copyWithCompanion(SharedExpensesCompanion data) {
    return SharedExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      description:
          data.description.present ? data.description.value : this.description,
      totalAmountPaisa: data.totalAmountPaisa.present
          ? data.totalAmountPaisa.value
          : this.totalAmountPaisa,
      paidById: data.paidById.present ? data.paidById.value : this.paidById,
      splitType: data.splitType.present ? data.splitType.value : this.splitType,
      participantsJson: data.participantsJson.present
          ? data.participantsJson.value
          : this.participantsJson,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      expenseDate:
          data.expenseDate.present ? data.expenseDate.value : this.expenseDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SharedExpenseRow(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('groupId: $groupId, ')
          ..write('description: $description, ')
          ..write('totalAmountPaisa: $totalAmountPaisa, ')
          ..write('paidById: $paidById, ')
          ..write('splitType: $splitType, ')
          ..write('participantsJson: $participantsJson, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      transactionId,
      groupId,
      description,
      totalAmountPaisa,
      paidById,
      splitType,
      participantsJson,
      status,
      notes,
      expenseDate,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SharedExpenseRow &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.groupId == this.groupId &&
          other.description == this.description &&
          other.totalAmountPaisa == this.totalAmountPaisa &&
          other.paidById == this.paidById &&
          other.splitType == this.splitType &&
          other.participantsJson == this.participantsJson &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.expenseDate == this.expenseDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SharedExpensesCompanion extends UpdateCompanion<SharedExpenseRow> {
  final Value<String> id;
  final Value<String?> transactionId;
  final Value<String?> groupId;
  final Value<String> description;
  final Value<int> totalAmountPaisa;
  final Value<String> paidById;
  final Value<SplitTypeDb> splitType;
  final Value<String> participantsJson;
  final Value<SettlementStatusDb> status;
  final Value<String?> notes;
  final Value<DateTime> expenseDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SharedExpensesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.description = const Value.absent(),
    this.totalAmountPaisa = const Value.absent(),
    this.paidById = const Value.absent(),
    this.splitType = const Value.absent(),
    this.participantsJson = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SharedExpensesCompanion.insert({
    required String id,
    this.transactionId = const Value.absent(),
    this.groupId = const Value.absent(),
    required String description,
    required int totalAmountPaisa,
    required String paidById,
    required SplitTypeDb splitType,
    required String participantsJson,
    required SettlementStatusDb status,
    this.notes = const Value.absent(),
    required DateTime expenseDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        description = Value(description),
        totalAmountPaisa = Value(totalAmountPaisa),
        paidById = Value(paidById),
        splitType = Value(splitType),
        participantsJson = Value(participantsJson),
        status = Value(status),
        expenseDate = Value(expenseDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SharedExpenseRow> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<String>? groupId,
    Expression<String>? description,
    Expression<int>? totalAmountPaisa,
    Expression<String>? paidById,
    Expression<int>? splitType,
    Expression<String>? participantsJson,
    Expression<int>? status,
    Expression<String>? notes,
    Expression<DateTime>? expenseDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (groupId != null) 'group_id': groupId,
      if (description != null) 'description': description,
      if (totalAmountPaisa != null) 'total_amount_paisa': totalAmountPaisa,
      if (paidById != null) 'paid_by_id': paidById,
      if (splitType != null) 'split_type': splitType,
      if (participantsJson != null) 'participants_json': participantsJson,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SharedExpensesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? transactionId,
      Value<String?>? groupId,
      Value<String>? description,
      Value<int>? totalAmountPaisa,
      Value<String>? paidById,
      Value<SplitTypeDb>? splitType,
      Value<String>? participantsJson,
      Value<SettlementStatusDb>? status,
      Value<String?>? notes,
      Value<DateTime>? expenseDate,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SharedExpensesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      groupId: groupId ?? this.groupId,
      description: description ?? this.description,
      totalAmountPaisa: totalAmountPaisa ?? this.totalAmountPaisa,
      paidById: paidById ?? this.paidById,
      splitType: splitType ?? this.splitType,
      participantsJson: participantsJson ?? this.participantsJson,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (totalAmountPaisa.present) {
      map['total_amount_paisa'] = Variable<int>(totalAmountPaisa.value);
    }
    if (paidById.present) {
      map['paid_by_id'] = Variable<String>(paidById.value);
    }
    if (splitType.present) {
      map['split_type'] = Variable<int>(
          $SharedExpensesTable.$convertersplitType.toSql(splitType.value));
    }
    if (participantsJson.present) {
      map['participants_json'] = Variable<String>(participantsJson.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $SharedExpensesTable.$converterstatus.toSql(status.value));
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<DateTime>(expenseDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedExpensesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('groupId: $groupId, ')
          ..write('description: $description, ')
          ..write('totalAmountPaisa: $totalAmountPaisa, ')
          ..write('paidById: $paidById, ')
          ..write('splitType: $splitType, ')
          ..write('participantsJson: $participantsJson, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettlementsTable extends Settlements
    with TableInfo<$SettlementsTable, SettlementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _friendIdMeta =
      const VerificationMeta('friendId');
  @override
  late final GeneratedColumn<String> friendId = GeneratedColumn<String>(
      'friend_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sharedExpenseIdMeta =
      const VerificationMeta('sharedExpenseId');
  @override
  late final GeneratedColumn<String> sharedExpenseId = GeneratedColumn<String>(
      'shared_expense_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isIncomingMeta =
      const VerificationMeta('isIncoming');
  @override
  late final GeneratedColumn<bool> isIncoming = GeneratedColumn<bool>(
      'is_incoming', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_incoming" IN (0, 1))'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _settledAtMeta =
      const VerificationMeta('settledAt');
  @override
  late final GeneratedColumn<DateTime> settledAt = GeneratedColumn<DateTime>(
      'settled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        friendId,
        sharedExpenseId,
        amountPaisa,
        isIncoming,
        notes,
        settledAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settlements';
  @override
  VerificationContext validateIntegrity(Insertable<SettlementRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('friend_id')) {
      context.handle(_friendIdMeta,
          friendId.isAcceptableOrUnknown(data['friend_id']!, _friendIdMeta));
    } else if (isInserting) {
      context.missing(_friendIdMeta);
    }
    if (data.containsKey('shared_expense_id')) {
      context.handle(
          _sharedExpenseIdMeta,
          sharedExpenseId.isAcceptableOrUnknown(
              data['shared_expense_id']!, _sharedExpenseIdMeta));
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('is_incoming')) {
      context.handle(
          _isIncomingMeta,
          isIncoming.isAcceptableOrUnknown(
              data['is_incoming']!, _isIncomingMeta));
    } else if (isInserting) {
      context.missing(_isIncomingMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('settled_at')) {
      context.handle(_settledAtMeta,
          settledAt.isAcceptableOrUnknown(data['settled_at']!, _settledAtMeta));
    } else if (isInserting) {
      context.missing(_settledAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettlementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettlementRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      friendId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}friend_id'])!,
      sharedExpenseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shared_expense_id']),
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      isIncoming: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_incoming'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      settledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}settled_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SettlementsTable createAlias(String alias) {
    return $SettlementsTable(attachedDatabase, alias);
  }
}

class SettlementRow extends DataClass implements Insertable<SettlementRow> {
  final String id;
  final String friendId;
  final String? sharedExpenseId;
  final int amountPaisa;
  final bool isIncoming;
  final String? notes;
  final DateTime settledAt;
  final DateTime createdAt;
  const SettlementRow(
      {required this.id,
      required this.friendId,
      this.sharedExpenseId,
      required this.amountPaisa,
      required this.isIncoming,
      this.notes,
      required this.settledAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['friend_id'] = Variable<String>(friendId);
    if (!nullToAbsent || sharedExpenseId != null) {
      map['shared_expense_id'] = Variable<String>(sharedExpenseId);
    }
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['is_incoming'] = Variable<bool>(isIncoming);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['settled_at'] = Variable<DateTime>(settledAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SettlementsCompanion toCompanion(bool nullToAbsent) {
    return SettlementsCompanion(
      id: Value(id),
      friendId: Value(friendId),
      sharedExpenseId: sharedExpenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedExpenseId),
      amountPaisa: Value(amountPaisa),
      isIncoming: Value(isIncoming),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      settledAt: Value(settledAt),
      createdAt: Value(createdAt),
    );
  }

  factory SettlementRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettlementRow(
      id: serializer.fromJson<String>(json['id']),
      friendId: serializer.fromJson<String>(json['friendId']),
      sharedExpenseId: serializer.fromJson<String?>(json['sharedExpenseId']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      isIncoming: serializer.fromJson<bool>(json['isIncoming']),
      notes: serializer.fromJson<String?>(json['notes']),
      settledAt: serializer.fromJson<DateTime>(json['settledAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'friendId': serializer.toJson<String>(friendId),
      'sharedExpenseId': serializer.toJson<String?>(sharedExpenseId),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'isIncoming': serializer.toJson<bool>(isIncoming),
      'notes': serializer.toJson<String?>(notes),
      'settledAt': serializer.toJson<DateTime>(settledAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SettlementRow copyWith(
          {String? id,
          String? friendId,
          Value<String?> sharedExpenseId = const Value.absent(),
          int? amountPaisa,
          bool? isIncoming,
          Value<String?> notes = const Value.absent(),
          DateTime? settledAt,
          DateTime? createdAt}) =>
      SettlementRow(
        id: id ?? this.id,
        friendId: friendId ?? this.friendId,
        sharedExpenseId: sharedExpenseId.present
            ? sharedExpenseId.value
            : this.sharedExpenseId,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        isIncoming: isIncoming ?? this.isIncoming,
        notes: notes.present ? notes.value : this.notes,
        settledAt: settledAt ?? this.settledAt,
        createdAt: createdAt ?? this.createdAt,
      );
  SettlementRow copyWithCompanion(SettlementsCompanion data) {
    return SettlementRow(
      id: data.id.present ? data.id.value : this.id,
      friendId: data.friendId.present ? data.friendId.value : this.friendId,
      sharedExpenseId: data.sharedExpenseId.present
          ? data.sharedExpenseId.value
          : this.sharedExpenseId,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      isIncoming:
          data.isIncoming.present ? data.isIncoming.value : this.isIncoming,
      notes: data.notes.present ? data.notes.value : this.notes,
      settledAt: data.settledAt.present ? data.settledAt.value : this.settledAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettlementRow(')
          ..write('id: $id, ')
          ..write('friendId: $friendId, ')
          ..write('sharedExpenseId: $sharedExpenseId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('isIncoming: $isIncoming, ')
          ..write('notes: $notes, ')
          ..write('settledAt: $settledAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, friendId, sharedExpenseId, amountPaisa,
      isIncoming, notes, settledAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettlementRow &&
          other.id == this.id &&
          other.friendId == this.friendId &&
          other.sharedExpenseId == this.sharedExpenseId &&
          other.amountPaisa == this.amountPaisa &&
          other.isIncoming == this.isIncoming &&
          other.notes == this.notes &&
          other.settledAt == this.settledAt &&
          other.createdAt == this.createdAt);
}

class SettlementsCompanion extends UpdateCompanion<SettlementRow> {
  final Value<String> id;
  final Value<String> friendId;
  final Value<String?> sharedExpenseId;
  final Value<int> amountPaisa;
  final Value<bool> isIncoming;
  final Value<String?> notes;
  final Value<DateTime> settledAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SettlementsCompanion({
    this.id = const Value.absent(),
    this.friendId = const Value.absent(),
    this.sharedExpenseId = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.isIncoming = const Value.absent(),
    this.notes = const Value.absent(),
    this.settledAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettlementsCompanion.insert({
    required String id,
    required String friendId,
    this.sharedExpenseId = const Value.absent(),
    required int amountPaisa,
    required bool isIncoming,
    this.notes = const Value.absent(),
    required DateTime settledAt,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        friendId = Value(friendId),
        amountPaisa = Value(amountPaisa),
        isIncoming = Value(isIncoming),
        settledAt = Value(settledAt),
        createdAt = Value(createdAt);
  static Insertable<SettlementRow> custom({
    Expression<String>? id,
    Expression<String>? friendId,
    Expression<String>? sharedExpenseId,
    Expression<int>? amountPaisa,
    Expression<bool>? isIncoming,
    Expression<String>? notes,
    Expression<DateTime>? settledAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (friendId != null) 'friend_id': friendId,
      if (sharedExpenseId != null) 'shared_expense_id': sharedExpenseId,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (isIncoming != null) 'is_incoming': isIncoming,
      if (notes != null) 'notes': notes,
      if (settledAt != null) 'settled_at': settledAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettlementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? friendId,
      Value<String?>? sharedExpenseId,
      Value<int>? amountPaisa,
      Value<bool>? isIncoming,
      Value<String?>? notes,
      Value<DateTime>? settledAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SettlementsCompanion(
      id: id ?? this.id,
      friendId: friendId ?? this.friendId,
      sharedExpenseId: sharedExpenseId ?? this.sharedExpenseId,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      isIncoming: isIncoming ?? this.isIncoming,
      notes: notes ?? this.notes,
      settledAt: settledAt ?? this.settledAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (friendId.present) {
      map['friend_id'] = Variable<String>(friendId.value);
    }
    if (sharedExpenseId.present) {
      map['shared_expense_id'] = Variable<String>(sharedExpenseId.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (isIncoming.present) {
      map['is_incoming'] = Variable<bool>(isIncoming.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (settledAt.present) {
      map['settled_at'] = Variable<DateTime>(settledAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettlementsCompanion(')
          ..write('id: $id, ')
          ..write('friendId: $friendId, ')
          ..write('sharedExpenseId: $sharedExpenseId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('isIncoming: $isIncoming, ')
          ..write('notes: $notes, ')
          ..write('settledAt: $settledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompletedLessonsTable extends CompletedLessons
    with TableInfo<$CompletedLessonsTable, CompletedLessonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletedLessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quizScoreMeta =
      const VerificationMeta('quizScore');
  @override
  late final GeneratedColumn<int> quizScore = GeneratedColumn<int>(
      'quiz_score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _timeSpentSecondsMeta =
      const VerificationMeta('timeSpentSeconds');
  @override
  late final GeneratedColumn<int> timeSpentSeconds = GeneratedColumn<int>(
      'time_spent_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lessonId, topicId, quizScore, timeSpentSeconds, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completed_lessons';
  @override
  VerificationContext validateIntegrity(Insertable<CompletedLessonRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('quiz_score')) {
      context.handle(_quizScoreMeta,
          quizScore.isAcceptableOrUnknown(data['quiz_score']!, _quizScoreMeta));
    }
    if (data.containsKey('time_spent_seconds')) {
      context.handle(
          _timeSpentSecondsMeta,
          timeSpentSeconds.isAcceptableOrUnknown(
              data['time_spent_seconds']!, _timeSpentSecondsMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompletedLessonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletedLessonRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id'])!,
      quizScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quiz_score']),
      timeSpentSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}time_spent_seconds'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $CompletedLessonsTable createAlias(String alias) {
    return $CompletedLessonsTable(attachedDatabase, alias);
  }
}

class CompletedLessonRow extends DataClass
    implements Insertable<CompletedLessonRow> {
  final String id;
  final String lessonId;
  final String topicId;
  final int? quizScore;
  final int timeSpentSeconds;
  final DateTime completedAt;
  const CompletedLessonRow(
      {required this.id,
      required this.lessonId,
      required this.topicId,
      this.quizScore,
      required this.timeSpentSeconds,
      required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['topic_id'] = Variable<String>(topicId);
    if (!nullToAbsent || quizScore != null) {
      map['quiz_score'] = Variable<int>(quizScore);
    }
    map['time_spent_seconds'] = Variable<int>(timeSpentSeconds);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  CompletedLessonsCompanion toCompanion(bool nullToAbsent) {
    return CompletedLessonsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      topicId: Value(topicId),
      quizScore: quizScore == null && nullToAbsent
          ? const Value.absent()
          : Value(quizScore),
      timeSpentSeconds: Value(timeSpentSeconds),
      completedAt: Value(completedAt),
    );
  }

  factory CompletedLessonRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletedLessonRow(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      topicId: serializer.fromJson<String>(json['topicId']),
      quizScore: serializer.fromJson<int?>(json['quizScore']),
      timeSpentSeconds: serializer.fromJson<int>(json['timeSpentSeconds']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'topicId': serializer.toJson<String>(topicId),
      'quizScore': serializer.toJson<int?>(quizScore),
      'timeSpentSeconds': serializer.toJson<int>(timeSpentSeconds),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  CompletedLessonRow copyWith(
          {String? id,
          String? lessonId,
          String? topicId,
          Value<int?> quizScore = const Value.absent(),
          int? timeSpentSeconds,
          DateTime? completedAt}) =>
      CompletedLessonRow(
        id: id ?? this.id,
        lessonId: lessonId ?? this.lessonId,
        topicId: topicId ?? this.topicId,
        quizScore: quizScore.present ? quizScore.value : this.quizScore,
        timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
        completedAt: completedAt ?? this.completedAt,
      );
  CompletedLessonRow copyWithCompanion(CompletedLessonsCompanion data) {
    return CompletedLessonRow(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      quizScore: data.quizScore.present ? data.quizScore.value : this.quizScore,
      timeSpentSeconds: data.timeSpentSeconds.present
          ? data.timeSpentSeconds.value
          : this.timeSpentSeconds,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletedLessonRow(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('topicId: $topicId, ')
          ..write('quizScore: $quizScore, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, lessonId, topicId, quizScore, timeSpentSeconds, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletedLessonRow &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.topicId == this.topicId &&
          other.quizScore == this.quizScore &&
          other.timeSpentSeconds == this.timeSpentSeconds &&
          other.completedAt == this.completedAt);
}

class CompletedLessonsCompanion extends UpdateCompanion<CompletedLessonRow> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<String> topicId;
  final Value<int?> quizScore;
  final Value<int> timeSpentSeconds;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const CompletedLessonsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.quizScore = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompletedLessonsCompanion.insert({
    required String id,
    required String lessonId,
    required String topicId,
    this.quizScore = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        lessonId = Value(lessonId),
        topicId = Value(topicId),
        completedAt = Value(completedAt);
  static Insertable<CompletedLessonRow> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? topicId,
    Expression<int>? quizScore,
    Expression<int>? timeSpentSeconds,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (topicId != null) 'topic_id': topicId,
      if (quizScore != null) 'quiz_score': quizScore,
      if (timeSpentSeconds != null) 'time_spent_seconds': timeSpentSeconds,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompletedLessonsCompanion copyWith(
      {Value<String>? id,
      Value<String>? lessonId,
      Value<String>? topicId,
      Value<int?>? quizScore,
      Value<int>? timeSpentSeconds,
      Value<DateTime>? completedAt,
      Value<int>? rowid}) {
    return CompletedLessonsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      topicId: topicId ?? this.topicId,
      quizScore: quizScore ?? this.quizScore,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (quizScore.present) {
      map['quiz_score'] = Variable<int>(quizScore.value);
    }
    if (timeSpentSeconds.present) {
      map['time_spent_seconds'] = Variable<int>(timeSpentSeconds.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletedLessonsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('topicId: $topicId, ')
          ..write('quizScore: $quizScore, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShownTipsTable extends ShownTips
    with TableInfo<$ShownTipsTable, ShownTipRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShownTipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipIdMeta = const VerificationMeta('tipId');
  @override
  late final GeneratedColumn<String> tipId = GeneratedColumn<String>(
      'tip_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wasDismissedMeta =
      const VerificationMeta('wasDismissed');
  @override
  late final GeneratedColumn<bool> wasDismissed = GeneratedColumn<bool>(
      'was_dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("was_dismissed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _wasSavedMeta =
      const VerificationMeta('wasSaved');
  @override
  late final GeneratedColumn<bool> wasSaved = GeneratedColumn<bool>(
      'was_saved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("was_saved" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _wasActedOnMeta =
      const VerificationMeta('wasActedOn');
  @override
  late final GeneratedColumn<bool> wasActedOn = GeneratedColumn<bool>(
      'was_acted_on', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("was_acted_on" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _shownAtMeta =
      const VerificationMeta('shownAt');
  @override
  late final GeneratedColumn<DateTime> shownAt = GeneratedColumn<DateTime>(
      'shown_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tipId, wasDismissed, wasSaved, wasActedOn, shownAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shown_tips';
  @override
  VerificationContext validateIntegrity(Insertable<ShownTipRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tip_id')) {
      context.handle(
          _tipIdMeta, tipId.isAcceptableOrUnknown(data['tip_id']!, _tipIdMeta));
    } else if (isInserting) {
      context.missing(_tipIdMeta);
    }
    if (data.containsKey('was_dismissed')) {
      context.handle(
          _wasDismissedMeta,
          wasDismissed.isAcceptableOrUnknown(
              data['was_dismissed']!, _wasDismissedMeta));
    }
    if (data.containsKey('was_saved')) {
      context.handle(_wasSavedMeta,
          wasSaved.isAcceptableOrUnknown(data['was_saved']!, _wasSavedMeta));
    }
    if (data.containsKey('was_acted_on')) {
      context.handle(
          _wasActedOnMeta,
          wasActedOn.isAcceptableOrUnknown(
              data['was_acted_on']!, _wasActedOnMeta));
    }
    if (data.containsKey('shown_at')) {
      context.handle(_shownAtMeta,
          shownAt.isAcceptableOrUnknown(data['shown_at']!, _shownAtMeta));
    } else if (isInserting) {
      context.missing(_shownAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShownTipRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShownTipRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tipId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tip_id'])!,
      wasDismissed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_dismissed'])!,
      wasSaved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_saved'])!,
      wasActedOn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_acted_on'])!,
      shownAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}shown_at'])!,
    );
  }

  @override
  $ShownTipsTable createAlias(String alias) {
    return $ShownTipsTable(attachedDatabase, alias);
  }
}

class ShownTipRow extends DataClass implements Insertable<ShownTipRow> {
  final String id;
  final String tipId;
  final bool wasDismissed;
  final bool wasSaved;
  final bool wasActedOn;
  final DateTime shownAt;
  const ShownTipRow(
      {required this.id,
      required this.tipId,
      required this.wasDismissed,
      required this.wasSaved,
      required this.wasActedOn,
      required this.shownAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tip_id'] = Variable<String>(tipId);
    map['was_dismissed'] = Variable<bool>(wasDismissed);
    map['was_saved'] = Variable<bool>(wasSaved);
    map['was_acted_on'] = Variable<bool>(wasActedOn);
    map['shown_at'] = Variable<DateTime>(shownAt);
    return map;
  }

  ShownTipsCompanion toCompanion(bool nullToAbsent) {
    return ShownTipsCompanion(
      id: Value(id),
      tipId: Value(tipId),
      wasDismissed: Value(wasDismissed),
      wasSaved: Value(wasSaved),
      wasActedOn: Value(wasActedOn),
      shownAt: Value(shownAt),
    );
  }

  factory ShownTipRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShownTipRow(
      id: serializer.fromJson<String>(json['id']),
      tipId: serializer.fromJson<String>(json['tipId']),
      wasDismissed: serializer.fromJson<bool>(json['wasDismissed']),
      wasSaved: serializer.fromJson<bool>(json['wasSaved']),
      wasActedOn: serializer.fromJson<bool>(json['wasActedOn']),
      shownAt: serializer.fromJson<DateTime>(json['shownAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tipId': serializer.toJson<String>(tipId),
      'wasDismissed': serializer.toJson<bool>(wasDismissed),
      'wasSaved': serializer.toJson<bool>(wasSaved),
      'wasActedOn': serializer.toJson<bool>(wasActedOn),
      'shownAt': serializer.toJson<DateTime>(shownAt),
    };
  }

  ShownTipRow copyWith(
          {String? id,
          String? tipId,
          bool? wasDismissed,
          bool? wasSaved,
          bool? wasActedOn,
          DateTime? shownAt}) =>
      ShownTipRow(
        id: id ?? this.id,
        tipId: tipId ?? this.tipId,
        wasDismissed: wasDismissed ?? this.wasDismissed,
        wasSaved: wasSaved ?? this.wasSaved,
        wasActedOn: wasActedOn ?? this.wasActedOn,
        shownAt: shownAt ?? this.shownAt,
      );
  ShownTipRow copyWithCompanion(ShownTipsCompanion data) {
    return ShownTipRow(
      id: data.id.present ? data.id.value : this.id,
      tipId: data.tipId.present ? data.tipId.value : this.tipId,
      wasDismissed: data.wasDismissed.present
          ? data.wasDismissed.value
          : this.wasDismissed,
      wasSaved: data.wasSaved.present ? data.wasSaved.value : this.wasSaved,
      wasActedOn:
          data.wasActedOn.present ? data.wasActedOn.value : this.wasActedOn,
      shownAt: data.shownAt.present ? data.shownAt.value : this.shownAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShownTipRow(')
          ..write('id: $id, ')
          ..write('tipId: $tipId, ')
          ..write('wasDismissed: $wasDismissed, ')
          ..write('wasSaved: $wasSaved, ')
          ..write('wasActedOn: $wasActedOn, ')
          ..write('shownAt: $shownAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tipId, wasDismissed, wasSaved, wasActedOn, shownAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShownTipRow &&
          other.id == this.id &&
          other.tipId == this.tipId &&
          other.wasDismissed == this.wasDismissed &&
          other.wasSaved == this.wasSaved &&
          other.wasActedOn == this.wasActedOn &&
          other.shownAt == this.shownAt);
}

class ShownTipsCompanion extends UpdateCompanion<ShownTipRow> {
  final Value<String> id;
  final Value<String> tipId;
  final Value<bool> wasDismissed;
  final Value<bool> wasSaved;
  final Value<bool> wasActedOn;
  final Value<DateTime> shownAt;
  final Value<int> rowid;
  const ShownTipsCompanion({
    this.id = const Value.absent(),
    this.tipId = const Value.absent(),
    this.wasDismissed = const Value.absent(),
    this.wasSaved = const Value.absent(),
    this.wasActedOn = const Value.absent(),
    this.shownAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShownTipsCompanion.insert({
    required String id,
    required String tipId,
    this.wasDismissed = const Value.absent(),
    this.wasSaved = const Value.absent(),
    this.wasActedOn = const Value.absent(),
    required DateTime shownAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tipId = Value(tipId),
        shownAt = Value(shownAt);
  static Insertable<ShownTipRow> custom({
    Expression<String>? id,
    Expression<String>? tipId,
    Expression<bool>? wasDismissed,
    Expression<bool>? wasSaved,
    Expression<bool>? wasActedOn,
    Expression<DateTime>? shownAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipId != null) 'tip_id': tipId,
      if (wasDismissed != null) 'was_dismissed': wasDismissed,
      if (wasSaved != null) 'was_saved': wasSaved,
      if (wasActedOn != null) 'was_acted_on': wasActedOn,
      if (shownAt != null) 'shown_at': shownAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShownTipsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tipId,
      Value<bool>? wasDismissed,
      Value<bool>? wasSaved,
      Value<bool>? wasActedOn,
      Value<DateTime>? shownAt,
      Value<int>? rowid}) {
    return ShownTipsCompanion(
      id: id ?? this.id,
      tipId: tipId ?? this.tipId,
      wasDismissed: wasDismissed ?? this.wasDismissed,
      wasSaved: wasSaved ?? this.wasSaved,
      wasActedOn: wasActedOn ?? this.wasActedOn,
      shownAt: shownAt ?? this.shownAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tipId.present) {
      map['tip_id'] = Variable<String>(tipId.value);
    }
    if (wasDismissed.present) {
      map['was_dismissed'] = Variable<bool>(wasDismissed.value);
    }
    if (wasSaved.present) {
      map['was_saved'] = Variable<bool>(wasSaved.value);
    }
    if (wasActedOn.present) {
      map['was_acted_on'] = Variable<bool>(wasActedOn.value);
    }
    if (shownAt.present) {
      map['shown_at'] = Variable<DateTime>(shownAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShownTipsCompanion(')
          ..write('id: $id, ')
          ..write('tipId: $tipId, ')
          ..write('wasDismissed: $wasDismissed, ')
          ..write('wasSaved: $wasSaved, ')
          ..write('wasActedOn: $wasActedOn, ')
          ..write('shownAt: $shownAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditScoresTable extends CreditScores
    with TableInfo<$CreditScoresTable, CreditScoreRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _factorsMeta =
      const VerificationMeta('factors');
  @override
  late final GeneratedColumn<String> factors = GeneratedColumn<String>(
      'factors', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, score, source, factors, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_scores';
  @override
  VerificationContext validateIntegrity(Insertable<CreditScoreRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('factors')) {
      context.handle(_factorsMeta,
          factors.isAcceptableOrUnknown(data['factors']!, _factorsMeta));
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditScoreRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditScoreRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      factors: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}factors']),
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  $CreditScoresTable createAlias(String alias) {
    return $CreditScoresTable(attachedDatabase, alias);
  }
}

class CreditScoreRow extends DataClass implements Insertable<CreditScoreRow> {
  final String id;
  final int score;
  final String source;
  final String? factors;
  final DateTime fetchedAt;
  const CreditScoreRow(
      {required this.id,
      required this.score,
      required this.source,
      this.factors,
      required this.fetchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['score'] = Variable<int>(score);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || factors != null) {
      map['factors'] = Variable<String>(factors);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CreditScoresCompanion toCompanion(bool nullToAbsent) {
    return CreditScoresCompanion(
      id: Value(id),
      score: Value(score),
      source: Value(source),
      factors: factors == null && nullToAbsent
          ? const Value.absent()
          : Value(factors),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CreditScoreRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditScoreRow(
      id: serializer.fromJson<String>(json['id']),
      score: serializer.fromJson<int>(json['score']),
      source: serializer.fromJson<String>(json['source']),
      factors: serializer.fromJson<String?>(json['factors']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'score': serializer.toJson<int>(score),
      'source': serializer.toJson<String>(source),
      'factors': serializer.toJson<String?>(factors),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CreditScoreRow copyWith(
          {String? id,
          int? score,
          String? source,
          Value<String?> factors = const Value.absent(),
          DateTime? fetchedAt}) =>
      CreditScoreRow(
        id: id ?? this.id,
        score: score ?? this.score,
        source: source ?? this.source,
        factors: factors.present ? factors.value : this.factors,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  CreditScoreRow copyWithCompanion(CreditScoresCompanion data) {
    return CreditScoreRow(
      id: data.id.present ? data.id.value : this.id,
      score: data.score.present ? data.score.value : this.score,
      source: data.source.present ? data.source.value : this.source,
      factors: data.factors.present ? data.factors.value : this.factors,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditScoreRow(')
          ..write('id: $id, ')
          ..write('score: $score, ')
          ..write('source: $source, ')
          ..write('factors: $factors, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, score, source, factors, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditScoreRow &&
          other.id == this.id &&
          other.score == this.score &&
          other.source == this.source &&
          other.factors == this.factors &&
          other.fetchedAt == this.fetchedAt);
}

class CreditScoresCompanion extends UpdateCompanion<CreditScoreRow> {
  final Value<String> id;
  final Value<int> score;
  final Value<String> source;
  final Value<String?> factors;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CreditScoresCompanion({
    this.id = const Value.absent(),
    this.score = const Value.absent(),
    this.source = const Value.absent(),
    this.factors = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditScoresCompanion.insert({
    required String id,
    required int score,
    required String source,
    this.factors = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        score = Value(score),
        source = Value(source),
        fetchedAt = Value(fetchedAt);
  static Insertable<CreditScoreRow> custom({
    Expression<String>? id,
    Expression<int>? score,
    Expression<String>? source,
    Expression<String>? factors,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (score != null) 'score': score,
      if (source != null) 'source': source,
      if (factors != null) 'factors': factors,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditScoresCompanion copyWith(
      {Value<String>? id,
      Value<int>? score,
      Value<String>? source,
      Value<String?>? factors,
      Value<DateTime>? fetchedAt,
      Value<int>? rowid}) {
    return CreditScoresCompanion(
      id: id ?? this.id,
      score: score ?? this.score,
      source: source ?? this.source,
      factors: factors ?? this.factors,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (factors.present) {
      map['factors'] = Variable<String>(factors.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditScoresCompanion(')
          ..write('id: $id, ')
          ..write('score: $score, ')
          ..write('source: $source, ')
          ..write('factors: $factors, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $LinkedAccountsTable linkedAccounts = $LinkedAccountsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $CustomCategoriesTable customCategories =
      $CustomCategoriesTable(this);
  late final $MerchantMappingsTable merchantMappings =
      $MerchantMappingsTable(this);
  late final $RecurringPatternsTable recurringPatterns =
      $RecurringPatternsTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $PrivacyReportsTable privacyReports = $PrivacyReportsTable(this);
  late final $BackupMetadataTable backupMetadata = $BackupMetadataTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $BalanceSnapshotsTable balanceSnapshots =
      $BalanceSnapshotsTable(this);
  late final $BillRemindersTable billReminders = $BillRemindersTable(this);
  late final $BillPaymentsTable billPayments = $BillPaymentsTable(this);
  late final $LoansTable loans = $LoansTable(this);
  late final $LoanPaymentsTable loanPayments = $LoanPaymentsTable(this);
  late final $CreditCardsTable creditCards = $CreditCardsTable(this);
  late final $InvestmentsTable investments = $InvestmentsTable(this);
  late final $InvestmentTransactionsTable investmentTransactions =
      $InvestmentTransactionsTable(this);
  late final $FriendsTable friends = $FriendsTable(this);
  late final $ExpenseGroupsTable expenseGroups = $ExpenseGroupsTable(this);
  late final $SharedExpensesTable sharedExpenses = $SharedExpensesTable(this);
  late final $SettlementsTable settlements = $SettlementsTable(this);
  late final $CompletedLessonsTable completedLessons =
      $CompletedLessonsTable(this);
  late final $ShownTipsTable shownTips = $ShownTipsTable(this);
  late final $CreditScoresTable creditScores = $CreditScoresTable(this);
  late final TransactionDao transactionDao =
      TransactionDao(this as AppDatabase);
  late final AccountDao accountDao = AccountDao(this as AppDatabase);
  late final BudgetDao budgetDao = BudgetDao(this as AppDatabase);
  late final AuditLogDao auditLogDao = AuditLogDao(this as AppDatabase);
  late final PrivacyReportDao privacyReportDao =
      PrivacyReportDao(this as AppDatabase);
  late final BackupMetadataDao backupMetadataDao =
      BackupMetadataDao(this as AppDatabase);
  late final SyncOutboxDao syncOutboxDao = SyncOutboxDao(this as AppDatabase);
  late final BalanceSnapshotDao balanceSnapshotDao =
      BalanceSnapshotDao(this as AppDatabase);
  late final BillReminderDao billReminderDao =
      BillReminderDao(this as AppDatabase);
  late final LoanDao loanDao = LoanDao(this as AppDatabase);
  late final InvestmentDao investmentDao = InvestmentDao(this as AppDatabase);
  late final FriendDao friendDao = FriendDao(this as AppDatabase);
  late final SharedExpenseDao sharedExpenseDao =
      SharedExpenseDao(this as AppDatabase);
  late final SettlementDao settlementDao = SettlementDao(this as AppDatabase);
  late final EducationDao educationDao = EducationDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        transactions,
        linkedAccounts,
        budgets,
        customCategories,
        merchantMappings,
        recurringPatterns,
        auditLogs,
        privacyReports,
        backupMetadata,
        syncOutbox,
        balanceSnapshots,
        billReminders,
        billPayments,
        loans,
        loanPayments,
        creditCards,
        investments,
        investmentTransactions,
        friends,
        expenseGroups,
        sharedExpenses,
        settlements,
        completedLessons,
        shownTips,
        creditScores
      ];
}

typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required int amountPaisa,
  required TransactionTypeDb type,
  required TransactionCategoryDb category,
  Value<String?> merchantName,
  Value<String?> description,
  required DateTime timestamp,
  required TransactionSourceDb source,
  Value<PaymentMethodDb?> paymentMethod,
  Value<String?> linkedAccountId,
  Value<String?> referenceId,
  Value<double?> categoryConfidence,
  Value<bool> isRecurring,
  Value<String?> recurringPatternId,
  Value<bool> isShared,
  Value<String?> sharedExpenseId,
  Value<String> tags,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<int> amountPaisa,
  Value<TransactionTypeDb> type,
  Value<TransactionCategoryDb> category,
  Value<String?> merchantName,
  Value<String?> description,
  Value<DateTime> timestamp,
  Value<TransactionSourceDb> source,
  Value<PaymentMethodDb?> paymentMethod,
  Value<String?> linkedAccountId,
  Value<String?> referenceId,
  Value<double?> categoryConfidence,
  Value<bool> isRecurring,
  Value<String?> recurringPatternId,
  Value<bool> isShared,
  Value<String?> sharedExpenseId,
  Value<String> tags,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionTypeDb, TransactionTypeDb, int>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<TransactionCategoryDb, TransactionCategoryDb,
          int>
      get category => $composableBuilder(
          column: $table.category,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionSourceDb, TransactionSourceDb, int>
      get source => $composableBuilder(
          column: $table.source,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<PaymentMethodDb?, PaymentMethodDb, int>
      get paymentMethod => $composableBuilder(
          column: $table.paymentMethod,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get linkedAccountId => $composableBuilder(
      column: $table.linkedAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get categoryConfidence => $composableBuilder(
      column: $table.categoryConfidence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurringPatternId => $composableBuilder(
      column: $table.recurringPatternId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isShared => $composableBuilder(
      column: $table.isShared, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sharedExpenseId => $composableBuilder(
      column: $table.sharedExpenseId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchantName => $composableBuilder(
      column: $table.merchantName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedAccountId => $composableBuilder(
      column: $table.linkedAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get categoryConfidence => $composableBuilder(
      column: $table.categoryConfidence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurringPatternId => $composableBuilder(
      column: $table.recurringPatternId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isShared => $composableBuilder(
      column: $table.isShared, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sharedExpenseId => $composableBuilder(
      column: $table.sharedExpenseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionTypeDb, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionCategoryDb, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionSourceDb, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentMethodDb?, int> get paymentMethod =>
      $composableBuilder(
          column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get linkedAccountId => $composableBuilder(
      column: $table.linkedAccountId, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => column);

  GeneratedColumn<double> get categoryConfidence => $composableBuilder(
      column: $table.categoryConfidence, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  GeneratedColumn<String> get recurringPatternId => $composableBuilder(
      column: $table.recurringPatternId, builder: (column) => column);

  GeneratedColumn<bool> get isShared =>
      $composableBuilder(column: $table.isShared, builder: (column) => column);

  GeneratedColumn<String> get sharedExpenseId => $composableBuilder(
      column: $table.sharedExpenseId, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    TransactionRow,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      TransactionRow,
      BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>
    ),
    TransactionRow,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<TransactionTypeDb> type = const Value.absent(),
            Value<TransactionCategoryDb> category = const Value.absent(),
            Value<String?> merchantName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<TransactionSourceDb> source = const Value.absent(),
            Value<PaymentMethodDb?> paymentMethod = const Value.absent(),
            Value<String?> linkedAccountId = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            Value<double?> categoryConfidence = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurringPatternId = const Value.absent(),
            Value<bool> isShared = const Value.absent(),
            Value<String?> sharedExpenseId = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            amountPaisa: amountPaisa,
            type: type,
            category: category,
            merchantName: merchantName,
            description: description,
            timestamp: timestamp,
            source: source,
            paymentMethod: paymentMethod,
            linkedAccountId: linkedAccountId,
            referenceId: referenceId,
            categoryConfidence: categoryConfidence,
            isRecurring: isRecurring,
            recurringPatternId: recurringPatternId,
            isShared: isShared,
            sharedExpenseId: sharedExpenseId,
            tags: tags,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int amountPaisa,
            required TransactionTypeDb type,
            required TransactionCategoryDb category,
            Value<String?> merchantName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required DateTime timestamp,
            required TransactionSourceDb source,
            Value<PaymentMethodDb?> paymentMethod = const Value.absent(),
            Value<String?> linkedAccountId = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            Value<double?> categoryConfidence = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurringPatternId = const Value.absent(),
            Value<bool> isShared = const Value.absent(),
            Value<String?> sharedExpenseId = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            amountPaisa: amountPaisa,
            type: type,
            category: category,
            merchantName: merchantName,
            description: description,
            timestamp: timestamp,
            source: source,
            paymentMethod: paymentMethod,
            linkedAccountId: linkedAccountId,
            referenceId: referenceId,
            categoryConfidence: categoryConfidence,
            isRecurring: isRecurring,
            recurringPatternId: recurringPatternId,
            isShared: isShared,
            sharedExpenseId: sharedExpenseId,
            tags: tags,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    TransactionRow,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      TransactionRow,
      BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>
    ),
    TransactionRow,
    PrefetchHooks Function()>;
typedef $$LinkedAccountsTableCreateCompanionBuilder = LinkedAccountsCompanion
    Function({
  required String id,
  required AccountProviderDb provider,
  Value<String?> accountNumber,
  Value<String?> accountName,
  Value<String?> upiId,
  Value<int?> balancePaisa,
  Value<DateTime?> balanceUpdatedAt,
  required AccountStatusDb status,
  Value<String?> accessToken,
  Value<String?> refreshToken,
  Value<DateTime?> tokenExpiresAt,
  required DateTime lastSyncedAt,
  required DateTime linkedAt,
  Value<bool> isPrimary,
  Value<String?> metadata,
  Value<int> rowid,
});
typedef $$LinkedAccountsTableUpdateCompanionBuilder = LinkedAccountsCompanion
    Function({
  Value<String> id,
  Value<AccountProviderDb> provider,
  Value<String?> accountNumber,
  Value<String?> accountName,
  Value<String?> upiId,
  Value<int?> balancePaisa,
  Value<DateTime?> balanceUpdatedAt,
  Value<AccountStatusDb> status,
  Value<String?> accessToken,
  Value<String?> refreshToken,
  Value<DateTime?> tokenExpiresAt,
  Value<DateTime> lastSyncedAt,
  Value<DateTime> linkedAt,
  Value<bool> isPrimary,
  Value<String?> metadata,
  Value<int> rowid,
});

class $$LinkedAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $LinkedAccountsTable> {
  $$LinkedAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccountProviderDb, AccountProviderDb, int>
      get provider => $composableBuilder(
          column: $table.provider,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get accountNumber => $composableBuilder(
      column: $table.accountNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountName => $composableBuilder(
      column: $table.accountName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get upiId => $composableBuilder(
      column: $table.upiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balancePaisa => $composableBuilder(
      column: $table.balancePaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get balanceUpdatedAt => $composableBuilder(
      column: $table.balanceUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccountStatusDb, AccountStatusDb, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tokenExpiresAt => $composableBuilder(
      column: $table.tokenExpiresAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get linkedAt => $composableBuilder(
      column: $table.linkedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrimary => $composableBuilder(
      column: $table.isPrimary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));
}

class $$LinkedAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $LinkedAccountsTable> {
  $$LinkedAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountNumber => $composableBuilder(
      column: $table.accountNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountName => $composableBuilder(
      column: $table.accountName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get upiId => $composableBuilder(
      column: $table.upiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balancePaisa => $composableBuilder(
      column: $table.balancePaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get balanceUpdatedAt => $composableBuilder(
      column: $table.balanceUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tokenExpiresAt => $composableBuilder(
      column: $table.tokenExpiresAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get linkedAt => $composableBuilder(
      column: $table.linkedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
      column: $table.isPrimary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$LinkedAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LinkedAccountsTable> {
  $$LinkedAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountProviderDb, int> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get accountNumber => $composableBuilder(
      column: $table.accountNumber, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
      column: $table.accountName, builder: (column) => column);

  GeneratedColumn<String> get upiId =>
      $composableBuilder(column: $table.upiId, builder: (column) => column);

  GeneratedColumn<int> get balancePaisa => $composableBuilder(
      column: $table.balancePaisa, builder: (column) => column);

  GeneratedColumn<DateTime> get balanceUpdatedAt => $composableBuilder(
      column: $table.balanceUpdatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountStatusDb, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => column);

  GeneratedColumn<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => column);

  GeneratedColumn<DateTime> get tokenExpiresAt => $composableBuilder(
      column: $table.tokenExpiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get linkedAt =>
      $composableBuilder(column: $table.linkedAt, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$LinkedAccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LinkedAccountsTable,
    LinkedAccountRow,
    $$LinkedAccountsTableFilterComposer,
    $$LinkedAccountsTableOrderingComposer,
    $$LinkedAccountsTableAnnotationComposer,
    $$LinkedAccountsTableCreateCompanionBuilder,
    $$LinkedAccountsTableUpdateCompanionBuilder,
    (
      LinkedAccountRow,
      BaseReferences<_$AppDatabase, $LinkedAccountsTable, LinkedAccountRow>
    ),
    LinkedAccountRow,
    PrefetchHooks Function()> {
  $$LinkedAccountsTableTableManager(
      _$AppDatabase db, $LinkedAccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LinkedAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LinkedAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LinkedAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<AccountProviderDb> provider = const Value.absent(),
            Value<String?> accountNumber = const Value.absent(),
            Value<String?> accountName = const Value.absent(),
            Value<String?> upiId = const Value.absent(),
            Value<int?> balancePaisa = const Value.absent(),
            Value<DateTime?> balanceUpdatedAt = const Value.absent(),
            Value<AccountStatusDb> status = const Value.absent(),
            Value<String?> accessToken = const Value.absent(),
            Value<String?> refreshToken = const Value.absent(),
            Value<DateTime?> tokenExpiresAt = const Value.absent(),
            Value<DateTime> lastSyncedAt = const Value.absent(),
            Value<DateTime> linkedAt = const Value.absent(),
            Value<bool> isPrimary = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LinkedAccountsCompanion(
            id: id,
            provider: provider,
            accountNumber: accountNumber,
            accountName: accountName,
            upiId: upiId,
            balancePaisa: balancePaisa,
            balanceUpdatedAt: balanceUpdatedAt,
            status: status,
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenExpiresAt: tokenExpiresAt,
            lastSyncedAt: lastSyncedAt,
            linkedAt: linkedAt,
            isPrimary: isPrimary,
            metadata: metadata,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required AccountProviderDb provider,
            Value<String?> accountNumber = const Value.absent(),
            Value<String?> accountName = const Value.absent(),
            Value<String?> upiId = const Value.absent(),
            Value<int?> balancePaisa = const Value.absent(),
            Value<DateTime?> balanceUpdatedAt = const Value.absent(),
            required AccountStatusDb status,
            Value<String?> accessToken = const Value.absent(),
            Value<String?> refreshToken = const Value.absent(),
            Value<DateTime?> tokenExpiresAt = const Value.absent(),
            required DateTime lastSyncedAt,
            required DateTime linkedAt,
            Value<bool> isPrimary = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LinkedAccountsCompanion.insert(
            id: id,
            provider: provider,
            accountNumber: accountNumber,
            accountName: accountName,
            upiId: upiId,
            balancePaisa: balancePaisa,
            balanceUpdatedAt: balanceUpdatedAt,
            status: status,
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenExpiresAt: tokenExpiresAt,
            lastSyncedAt: lastSyncedAt,
            linkedAt: linkedAt,
            isPrimary: isPrimary,
            metadata: metadata,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LinkedAccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LinkedAccountsTable,
    LinkedAccountRow,
    $$LinkedAccountsTableFilterComposer,
    $$LinkedAccountsTableOrderingComposer,
    $$LinkedAccountsTableAnnotationComposer,
    $$LinkedAccountsTableCreateCompanionBuilder,
    $$LinkedAccountsTableUpdateCompanionBuilder,
    (
      LinkedAccountRow,
      BaseReferences<_$AppDatabase, $LinkedAccountsTable, LinkedAccountRow>
    ),
    LinkedAccountRow,
    PrefetchHooks Function()>;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required String id,
  required String name,
  required int limitPaisa,
  Value<int> spentPaisa,
  required BudgetPeriodDb period,
  Value<TransactionCategoryDb?> category,
  Value<double> alertThreshold,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> limitPaisa,
  Value<int> spentPaisa,
  Value<BudgetPeriodDb> period,
  Value<TransactionCategoryDb?> category,
  Value<double> alertThreshold,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get limitPaisa => $composableBuilder(
      column: $table.limitPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get spentPaisa => $composableBuilder(
      column: $table.spentPaisa, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<BudgetPeriodDb, BudgetPeriodDb, int>
      get period => $composableBuilder(
          column: $table.period,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<TransactionCategoryDb?, TransactionCategoryDb,
          int>
      get category => $composableBuilder(
          column: $table.category,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get alertThreshold => $composableBuilder(
      column: $table.alertThreshold,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get limitPaisa => $composableBuilder(
      column: $table.limitPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get spentPaisa => $composableBuilder(
      column: $table.spentPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get alertThreshold => $composableBuilder(
      column: $table.alertThreshold,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get limitPaisa => $composableBuilder(
      column: $table.limitPaisa, builder: (column) => column);

  GeneratedColumn<int> get spentPaisa => $composableBuilder(
      column: $table.spentPaisa, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BudgetPeriodDb, int> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionCategoryDb?, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get alertThreshold => $composableBuilder(
      column: $table.alertThreshold, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTable,
    BudgetRow,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
    BudgetRow,
    PrefetchHooks Function()> {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> limitPaisa = const Value.absent(),
            Value<int> spentPaisa = const Value.absent(),
            Value<BudgetPeriodDb> period = const Value.absent(),
            Value<TransactionCategoryDb?> category = const Value.absent(),
            Value<double> alertThreshold = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion(
            id: id,
            name: name,
            limitPaisa: limitPaisa,
            spentPaisa: spentPaisa,
            period: period,
            category: category,
            alertThreshold: alertThreshold,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int limitPaisa,
            Value<int> spentPaisa = const Value.absent(),
            required BudgetPeriodDb period,
            Value<TransactionCategoryDb?> category = const Value.absent(),
            Value<double> alertThreshold = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion.insert(
            id: id,
            name: name,
            limitPaisa: limitPaisa,
            spentPaisa: spentPaisa,
            period: period,
            category: category,
            alertThreshold: alertThreshold,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTable,
    BudgetRow,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
    BudgetRow,
    PrefetchHooks Function()>;
typedef $$CustomCategoriesTableCreateCompanionBuilder
    = CustomCategoriesCompanion Function({
  required String id,
  required String name,
  Value<String?> nameHi,
  required int iconCodePoint,
  required int colorValue,
  Value<String> keywords,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CustomCategoriesTableUpdateCompanionBuilder
    = CustomCategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> nameHi,
  Value<int> iconCodePoint,
  Value<int> colorValue,
  Value<String> keywords,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CustomCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameHi => $composableBuilder(
      column: $table.nameHi, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keywords => $composableBuilder(
      column: $table.keywords, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CustomCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameHi => $composableBuilder(
      column: $table.nameHi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keywords => $composableBuilder(
      column: $table.keywords, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameHi =>
      $composableBuilder(column: $table.nameHi, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomCategoriesTable,
    CustomCategory,
    $$CustomCategoriesTableFilterComposer,
    $$CustomCategoriesTableOrderingComposer,
    $$CustomCategoriesTableAnnotationComposer,
    $$CustomCategoriesTableCreateCompanionBuilder,
    $$CustomCategoriesTableUpdateCompanionBuilder,
    (
      CustomCategory,
      BaseReferences<_$AppDatabase, $CustomCategoriesTable, CustomCategory>
    ),
    CustomCategory,
    PrefetchHooks Function()> {
  $$CustomCategoriesTableTableManager(
      _$AppDatabase db, $CustomCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameHi = const Value.absent(),
            Value<int> iconCodePoint = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<String> keywords = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomCategoriesCompanion(
            id: id,
            name: name,
            nameHi: nameHi,
            iconCodePoint: iconCodePoint,
            colorValue: colorValue,
            keywords: keywords,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> nameHi = const Value.absent(),
            required int iconCodePoint,
            required int colorValue,
            Value<String> keywords = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomCategoriesCompanion.insert(
            id: id,
            name: name,
            nameHi: nameHi,
            iconCodePoint: iconCodePoint,
            colorValue: colorValue,
            keywords: keywords,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomCategoriesTable,
    CustomCategory,
    $$CustomCategoriesTableFilterComposer,
    $$CustomCategoriesTableOrderingComposer,
    $$CustomCategoriesTableAnnotationComposer,
    $$CustomCategoriesTableCreateCompanionBuilder,
    $$CustomCategoriesTableUpdateCompanionBuilder,
    (
      CustomCategory,
      BaseReferences<_$AppDatabase, $CustomCategoriesTable, CustomCategory>
    ),
    CustomCategory,
    PrefetchHooks Function()>;
typedef $$MerchantMappingsTableCreateCompanionBuilder
    = MerchantMappingsCompanion Function({
  required String merchantPattern,
  required TransactionCategoryDb category,
  Value<int> correctionCount,
  required DateTime lastUsed,
  Value<int> rowid,
});
typedef $$MerchantMappingsTableUpdateCompanionBuilder
    = MerchantMappingsCompanion Function({
  Value<String> merchantPattern,
  Value<TransactionCategoryDb> category,
  Value<int> correctionCount,
  Value<DateTime> lastUsed,
  Value<int> rowid,
});

class $$MerchantMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantMappingsTable> {
  $$MerchantMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get merchantPattern => $composableBuilder(
      column: $table.merchantPattern,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionCategoryDb, TransactionCategoryDb,
          int>
      get category => $composableBuilder(
          column: $table.category,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get correctionCount => $composableBuilder(
      column: $table.correctionCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsed => $composableBuilder(
      column: $table.lastUsed, builder: (column) => ColumnFilters(column));
}

class $$MerchantMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantMappingsTable> {
  $$MerchantMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get merchantPattern => $composableBuilder(
      column: $table.merchantPattern,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctionCount => $composableBuilder(
      column: $table.correctionCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsed => $composableBuilder(
      column: $table.lastUsed, builder: (column) => ColumnOrderings(column));
}

class $$MerchantMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantMappingsTable> {
  $$MerchantMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get merchantPattern => $composableBuilder(
      column: $table.merchantPattern, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionCategoryDb, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get correctionCount => $composableBuilder(
      column: $table.correctionCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsed =>
      $composableBuilder(column: $table.lastUsed, builder: (column) => column);
}

class $$MerchantMappingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MerchantMappingsTable,
    MerchantMapping,
    $$MerchantMappingsTableFilterComposer,
    $$MerchantMappingsTableOrderingComposer,
    $$MerchantMappingsTableAnnotationComposer,
    $$MerchantMappingsTableCreateCompanionBuilder,
    $$MerchantMappingsTableUpdateCompanionBuilder,
    (
      MerchantMapping,
      BaseReferences<_$AppDatabase, $MerchantMappingsTable, MerchantMapping>
    ),
    MerchantMapping,
    PrefetchHooks Function()> {
  $$MerchantMappingsTableTableManager(
      _$AppDatabase db, $MerchantMappingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MerchantMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MerchantMappingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> merchantPattern = const Value.absent(),
            Value<TransactionCategoryDb> category = const Value.absent(),
            Value<int> correctionCount = const Value.absent(),
            Value<DateTime> lastUsed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MerchantMappingsCompanion(
            merchantPattern: merchantPattern,
            category: category,
            correctionCount: correctionCount,
            lastUsed: lastUsed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String merchantPattern,
            required TransactionCategoryDb category,
            Value<int> correctionCount = const Value.absent(),
            required DateTime lastUsed,
            Value<int> rowid = const Value.absent(),
          }) =>
              MerchantMappingsCompanion.insert(
            merchantPattern: merchantPattern,
            category: category,
            correctionCount: correctionCount,
            lastUsed: lastUsed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MerchantMappingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MerchantMappingsTable,
    MerchantMapping,
    $$MerchantMappingsTableFilterComposer,
    $$MerchantMappingsTableOrderingComposer,
    $$MerchantMappingsTableAnnotationComposer,
    $$MerchantMappingsTableCreateCompanionBuilder,
    $$MerchantMappingsTableUpdateCompanionBuilder,
    (
      MerchantMapping,
      BaseReferences<_$AppDatabase, $MerchantMappingsTable, MerchantMapping>
    ),
    MerchantMapping,
    PrefetchHooks Function()>;
typedef $$RecurringPatternsTableCreateCompanionBuilder
    = RecurringPatternsCompanion Function({
  required String id,
  required String name,
  required int amountPaisa,
  required TransactionCategoryDb category,
  required int frequencyDays,
  required DateTime nextExpected,
  Value<String?> linkedAccountId,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$RecurringPatternsTableUpdateCompanionBuilder
    = RecurringPatternsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> amountPaisa,
  Value<TransactionCategoryDb> category,
  Value<int> frequencyDays,
  Value<DateTime> nextExpected,
  Value<String?> linkedAccountId,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$RecurringPatternsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringPatternsTable> {
  $$RecurringPatternsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionCategoryDb, TransactionCategoryDb,
          int>
      get category => $composableBuilder(
          column: $table.category,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get frequencyDays => $composableBuilder(
      column: $table.frequencyDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextExpected => $composableBuilder(
      column: $table.nextExpected, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedAccountId => $composableBuilder(
      column: $table.linkedAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$RecurringPatternsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringPatternsTable> {
  $$RecurringPatternsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frequencyDays => $composableBuilder(
      column: $table.frequencyDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextExpected => $composableBuilder(
      column: $table.nextExpected,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedAccountId => $composableBuilder(
      column: $table.linkedAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$RecurringPatternsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringPatternsTable> {
  $$RecurringPatternsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionCategoryDb, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get frequencyDays => $composableBuilder(
      column: $table.frequencyDays, builder: (column) => column);

  GeneratedColumn<DateTime> get nextExpected => $composableBuilder(
      column: $table.nextExpected, builder: (column) => column);

  GeneratedColumn<String> get linkedAccountId => $composableBuilder(
      column: $table.linkedAccountId, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$RecurringPatternsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringPatternsTable,
    RecurringPattern,
    $$RecurringPatternsTableFilterComposer,
    $$RecurringPatternsTableOrderingComposer,
    $$RecurringPatternsTableAnnotationComposer,
    $$RecurringPatternsTableCreateCompanionBuilder,
    $$RecurringPatternsTableUpdateCompanionBuilder,
    (
      RecurringPattern,
      BaseReferences<_$AppDatabase, $RecurringPatternsTable, RecurringPattern>
    ),
    RecurringPattern,
    PrefetchHooks Function()> {
  $$RecurringPatternsTableTableManager(
      _$AppDatabase db, $RecurringPatternsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringPatternsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringPatternsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringPatternsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<TransactionCategoryDb> category = const Value.absent(),
            Value<int> frequencyDays = const Value.absent(),
            Value<DateTime> nextExpected = const Value.absent(),
            Value<String?> linkedAccountId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPatternsCompanion(
            id: id,
            name: name,
            amountPaisa: amountPaisa,
            category: category,
            frequencyDays: frequencyDays,
            nextExpected: nextExpected,
            linkedAccountId: linkedAccountId,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int amountPaisa,
            required TransactionCategoryDb category,
            required int frequencyDays,
            required DateTime nextExpected,
            Value<String?> linkedAccountId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPatternsCompanion.insert(
            id: id,
            name: name,
            amountPaisa: amountPaisa,
            category: category,
            frequencyDays: frequencyDays,
            nextExpected: nextExpected,
            linkedAccountId: linkedAccountId,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurringPatternsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurringPatternsTable,
    RecurringPattern,
    $$RecurringPatternsTableFilterComposer,
    $$RecurringPatternsTableOrderingComposer,
    $$RecurringPatternsTableAnnotationComposer,
    $$RecurringPatternsTableCreateCompanionBuilder,
    $$RecurringPatternsTableUpdateCompanionBuilder,
    (
      RecurringPattern,
      BaseReferences<_$AppDatabase, $RecurringPatternsTable, RecurringPattern>
    ),
    RecurringPattern,
    PrefetchHooks Function()>;
typedef $$AuditLogsTableCreateCompanionBuilder = AuditLogsCompanion Function({
  required String id,
  required AuditLogTypeDb type,
  required String entity,
  Value<String?> entityId,
  Value<String?> details,
  Value<String?> metadata,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$AuditLogsTableUpdateCompanionBuilder = AuditLogsCompanion Function({
  Value<String> id,
  Value<AuditLogTypeDb> type,
  Value<String> entity,
  Value<String?> entityId,
  Value<String?> details,
  Value<String?> metadata,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AuditLogTypeDb, AuditLogTypeDb, int>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AuditLogTypeDb, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLogRow,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLogRow, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLogRow>),
    AuditLogRow,
    PrefetchHooks Function()> {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<AuditLogTypeDb> type = const Value.absent(),
            Value<String> entity = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsCompanion(
            id: id,
            type: type,
            entity: entity,
            entityId: entityId,
            details: details,
            metadata: metadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required AuditLogTypeDb type,
            required String entity,
            Value<String?> entityId = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsCompanion.insert(
            id: id,
            type: type,
            entity: entity,
            entityId: entityId,
            details: details,
            metadata: metadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuditLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLogRow,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLogRow, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLogRow>),
    AuditLogRow,
    PrefetchHooks Function()>;
typedef $$PrivacyReportsTableCreateCompanionBuilder = PrivacyReportsCompanion
    Function({
  required String id,
  required DateTime generatedAt,
  required String reportJson,
  Value<int> rowid,
});
typedef $$PrivacyReportsTableUpdateCompanionBuilder = PrivacyReportsCompanion
    Function({
  Value<String> id,
  Value<DateTime> generatedAt,
  Value<String> reportJson,
  Value<int> rowid,
});

class $$PrivacyReportsTableFilterComposer
    extends Composer<_$AppDatabase, $PrivacyReportsTable> {
  $$PrivacyReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reportJson => $composableBuilder(
      column: $table.reportJson, builder: (column) => ColumnFilters(column));
}

class $$PrivacyReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrivacyReportsTable> {
  $$PrivacyReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reportJson => $composableBuilder(
      column: $table.reportJson, builder: (column) => ColumnOrderings(column));
}

class $$PrivacyReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrivacyReportsTable> {
  $$PrivacyReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);

  GeneratedColumn<String> get reportJson => $composableBuilder(
      column: $table.reportJson, builder: (column) => column);
}

class $$PrivacyReportsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrivacyReportsTable,
    PrivacyReportRow,
    $$PrivacyReportsTableFilterComposer,
    $$PrivacyReportsTableOrderingComposer,
    $$PrivacyReportsTableAnnotationComposer,
    $$PrivacyReportsTableCreateCompanionBuilder,
    $$PrivacyReportsTableUpdateCompanionBuilder,
    (
      PrivacyReportRow,
      BaseReferences<_$AppDatabase, $PrivacyReportsTable, PrivacyReportRow>
    ),
    PrivacyReportRow,
    PrefetchHooks Function()> {
  $$PrivacyReportsTableTableManager(
      _$AppDatabase db, $PrivacyReportsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrivacyReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrivacyReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrivacyReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<String> reportJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrivacyReportsCompanion(
            id: id,
            generatedAt: generatedAt,
            reportJson: reportJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime generatedAt,
            required String reportJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              PrivacyReportsCompanion.insert(
            id: id,
            generatedAt: generatedAt,
            reportJson: reportJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PrivacyReportsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PrivacyReportsTable,
    PrivacyReportRow,
    $$PrivacyReportsTableFilterComposer,
    $$PrivacyReportsTableOrderingComposer,
    $$PrivacyReportsTableAnnotationComposer,
    $$PrivacyReportsTableCreateCompanionBuilder,
    $$PrivacyReportsTableUpdateCompanionBuilder,
    (
      PrivacyReportRow,
      BaseReferences<_$AppDatabase, $PrivacyReportsTable, PrivacyReportRow>
    ),
    PrivacyReportRow,
    PrefetchHooks Function()>;
typedef $$BackupMetadataTableCreateCompanionBuilder = BackupMetadataCompanion
    Function({
  required String id,
  required String filePath,
  required DateTime createdAt,
  required int sizeBytes,
  required String checksum,
  required int version,
  Value<bool> isEncrypted,
  required BackupStatusDb status,
  Value<int> restoreCount,
  Value<DateTime?> lastRestoredAt,
  Value<int> rowid,
});
typedef $$BackupMetadataTableUpdateCompanionBuilder = BackupMetadataCompanion
    Function({
  Value<String> id,
  Value<String> filePath,
  Value<DateTime> createdAt,
  Value<int> sizeBytes,
  Value<String> checksum,
  Value<int> version,
  Value<bool> isEncrypted,
  Value<BackupStatusDb> status,
  Value<int> restoreCount,
  Value<DateTime?> lastRestoredAt,
  Value<int> rowid,
});

class $$BackupMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $BackupMetadataTable> {
  $$BackupMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<BackupStatusDb, BackupStatusDb, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get restoreCount => $composableBuilder(
      column: $table.restoreCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastRestoredAt => $composableBuilder(
      column: $table.lastRestoredAt,
      builder: (column) => ColumnFilters(column));
}

class $$BackupMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupMetadataTable> {
  $$BackupMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restoreCount => $composableBuilder(
      column: $table.restoreCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastRestoredAt => $composableBuilder(
      column: $table.lastRestoredAt,
      builder: (column) => ColumnOrderings(column));
}

class $$BackupMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupMetadataTable> {
  $$BackupMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BackupStatusDb, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get restoreCount => $composableBuilder(
      column: $table.restoreCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRestoredAt => $composableBuilder(
      column: $table.lastRestoredAt, builder: (column) => column);
}

class $$BackupMetadataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BackupMetadataTable,
    BackupMetadataRow,
    $$BackupMetadataTableFilterComposer,
    $$BackupMetadataTableOrderingComposer,
    $$BackupMetadataTableAnnotationComposer,
    $$BackupMetadataTableCreateCompanionBuilder,
    $$BackupMetadataTableUpdateCompanionBuilder,
    (
      BackupMetadataRow,
      BaseReferences<_$AppDatabase, $BackupMetadataTable, BackupMetadataRow>
    ),
    BackupMetadataRow,
    PrefetchHooks Function()> {
  $$BackupMetadataTableTableManager(
      _$AppDatabase db, $BackupMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> sizeBytes = const Value.absent(),
            Value<String> checksum = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            Value<BackupStatusDb> status = const Value.absent(),
            Value<int> restoreCount = const Value.absent(),
            Value<DateTime?> lastRestoredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupMetadataCompanion(
            id: id,
            filePath: filePath,
            createdAt: createdAt,
            sizeBytes: sizeBytes,
            checksum: checksum,
            version: version,
            isEncrypted: isEncrypted,
            status: status,
            restoreCount: restoreCount,
            lastRestoredAt: lastRestoredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String filePath,
            required DateTime createdAt,
            required int sizeBytes,
            required String checksum,
            required int version,
            Value<bool> isEncrypted = const Value.absent(),
            required BackupStatusDb status,
            Value<int> restoreCount = const Value.absent(),
            Value<DateTime?> lastRestoredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupMetadataCompanion.insert(
            id: id,
            filePath: filePath,
            createdAt: createdAt,
            sizeBytes: sizeBytes,
            checksum: checksum,
            version: version,
            isEncrypted: isEncrypted,
            status: status,
            restoreCount: restoreCount,
            lastRestoredAt: lastRestoredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BackupMetadataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BackupMetadataTable,
    BackupMetadataRow,
    $$BackupMetadataTableFilterComposer,
    $$BackupMetadataTableOrderingComposer,
    $$BackupMetadataTableAnnotationComposer,
    $$BackupMetadataTableCreateCompanionBuilder,
    $$BackupMetadataTableUpdateCompanionBuilder,
    (
      BackupMetadataRow,
      BaseReferences<_$AppDatabase, $BackupMetadataTable, BackupMetadataRow>
    ),
    BackupMetadataRow,
    PrefetchHooks Function()>;
typedef $$SyncOutboxTableCreateCompanionBuilder = SyncOutboxCompanion Function({
  required String transactionId,
  required SyncOutboxStatusDb status,
  Value<int> attempts,
  Value<DateTime?> nextAttemptAt,
  Value<String?> lastError,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SyncOutboxTableUpdateCompanionBuilder = SyncOutboxCompanion Function({
  Value<String> transactionId,
  Value<SyncOutboxStatusDb> status,
  Value<int> attempts,
  Value<DateTime?> nextAttemptAt,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SyncOutboxStatusDb, SyncOutboxStatusDb, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncOutboxStatusDb, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncOutboxTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncOutboxTable,
    SyncOutboxRow,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxRow,
      BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>
    ),
    SyncOutboxRow,
    PrefetchHooks Function()> {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> transactionId = const Value.absent(),
            Value<SyncOutboxStatusDb> status = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxCompanion(
            transactionId: transactionId,
            status: status,
            attempts: attempts,
            nextAttemptAt: nextAttemptAt,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String transactionId,
            required SyncOutboxStatusDb status,
            Value<int> attempts = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxCompanion.insert(
            transactionId: transactionId,
            status: status,
            attempts: attempts,
            nextAttemptAt: nextAttemptAt,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncOutboxTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncOutboxTable,
    SyncOutboxRow,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxRow,
      BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>
    ),
    SyncOutboxRow,
    PrefetchHooks Function()>;
typedef $$BalanceSnapshotsTableCreateCompanionBuilder
    = BalanceSnapshotsCompanion Function({
  required String id,
  required String accountId,
  required int balancePaisa,
  required DateTime timestamp,
  Value<int> rowid,
});
typedef $$BalanceSnapshotsTableUpdateCompanionBuilder
    = BalanceSnapshotsCompanion Function({
  Value<String> id,
  Value<String> accountId,
  Value<int> balancePaisa,
  Value<DateTime> timestamp,
  Value<int> rowid,
});

class $$BalanceSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotsTable> {
  $$BalanceSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balancePaisa => $composableBuilder(
      column: $table.balancePaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$BalanceSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotsTable> {
  $$BalanceSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balancePaisa => $composableBuilder(
      column: $table.balancePaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$BalanceSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotsTable> {
  $$BalanceSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get balancePaisa => $composableBuilder(
      column: $table.balancePaisa, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$BalanceSnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BalanceSnapshotsTable,
    BalanceSnapshotRow,
    $$BalanceSnapshotsTableFilterComposer,
    $$BalanceSnapshotsTableOrderingComposer,
    $$BalanceSnapshotsTableAnnotationComposer,
    $$BalanceSnapshotsTableCreateCompanionBuilder,
    $$BalanceSnapshotsTableUpdateCompanionBuilder,
    (
      BalanceSnapshotRow,
      BaseReferences<_$AppDatabase, $BalanceSnapshotsTable, BalanceSnapshotRow>
    ),
    BalanceSnapshotRow,
    PrefetchHooks Function()> {
  $$BalanceSnapshotsTableTableManager(
      _$AppDatabase db, $BalanceSnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BalanceSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BalanceSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BalanceSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<int> balancePaisa = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BalanceSnapshotsCompanion(
            id: id,
            accountId: accountId,
            balancePaisa: balancePaisa,
            timestamp: timestamp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String accountId,
            required int balancePaisa,
            required DateTime timestamp,
            Value<int> rowid = const Value.absent(),
          }) =>
              BalanceSnapshotsCompanion.insert(
            id: id,
            accountId: accountId,
            balancePaisa: balancePaisa,
            timestamp: timestamp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BalanceSnapshotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BalanceSnapshotsTable,
    BalanceSnapshotRow,
    $$BalanceSnapshotsTableFilterComposer,
    $$BalanceSnapshotsTableOrderingComposer,
    $$BalanceSnapshotsTableAnnotationComposer,
    $$BalanceSnapshotsTableCreateCompanionBuilder,
    $$BalanceSnapshotsTableUpdateCompanionBuilder,
    (
      BalanceSnapshotRow,
      BaseReferences<_$AppDatabase, $BalanceSnapshotsTable, BalanceSnapshotRow>
    ),
    BalanceSnapshotRow,
    PrefetchHooks Function()>;
typedef $$BillRemindersTableCreateCompanionBuilder = BillRemindersCompanion
    Function({
  required String id,
  required String name,
  Value<String?> merchantName,
  required int amountPaisa,
  required BillFrequencyDb frequency,
  required DateTime nextDueDate,
  Value<int> reminderDaysBefore,
  Value<bool> isAutoDetected,
  Value<bool> isActive,
  Value<String?> linkedAccountId,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BillRemindersTableUpdateCompanionBuilder = BillRemindersCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> merchantName,
  Value<int> amountPaisa,
  Value<BillFrequencyDb> frequency,
  Value<DateTime> nextDueDate,
  Value<int> reminderDaysBefore,
  Value<bool> isAutoDetected,
  Value<bool> isActive,
  Value<String?> linkedAccountId,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BillRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $BillRemindersTable> {
  $$BillRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<BillFrequencyDb, BillFrequencyDb, int>
      get frequency => $composableBuilder(
          column: $table.frequency,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderDaysBefore => $composableBuilder(
      column: $table.reminderDaysBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAutoDetected => $composableBuilder(
      column: $table.isAutoDetected,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedAccountId => $composableBuilder(
      column: $table.linkedAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BillRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $BillRemindersTable> {
  $$BillRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchantName => $composableBuilder(
      column: $table.merchantName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderDaysBefore => $composableBuilder(
      column: $table.reminderDaysBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAutoDetected => $composableBuilder(
      column: $table.isAutoDetected,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedAccountId => $composableBuilder(
      column: $table.linkedAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BillRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillRemindersTable> {
  $$BillRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get merchantName => $composableBuilder(
      column: $table.merchantName, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BillFrequencyDb, int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => column);

  GeneratedColumn<int> get reminderDaysBefore => $composableBuilder(
      column: $table.reminderDaysBefore, builder: (column) => column);

  GeneratedColumn<bool> get isAutoDetected => $composableBuilder(
      column: $table.isAutoDetected, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get linkedAccountId => $composableBuilder(
      column: $table.linkedAccountId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BillRemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillRemindersTable,
    BillReminderRow,
    $$BillRemindersTableFilterComposer,
    $$BillRemindersTableOrderingComposer,
    $$BillRemindersTableAnnotationComposer,
    $$BillRemindersTableCreateCompanionBuilder,
    $$BillRemindersTableUpdateCompanionBuilder,
    (
      BillReminderRow,
      BaseReferences<_$AppDatabase, $BillRemindersTable, BillReminderRow>
    ),
    BillReminderRow,
    PrefetchHooks Function()> {
  $$BillRemindersTableTableManager(_$AppDatabase db, $BillRemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> merchantName = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<BillFrequencyDb> frequency = const Value.absent(),
            Value<DateTime> nextDueDate = const Value.absent(),
            Value<int> reminderDaysBefore = const Value.absent(),
            Value<bool> isAutoDetected = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> linkedAccountId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillRemindersCompanion(
            id: id,
            name: name,
            merchantName: merchantName,
            amountPaisa: amountPaisa,
            frequency: frequency,
            nextDueDate: nextDueDate,
            reminderDaysBefore: reminderDaysBefore,
            isAutoDetected: isAutoDetected,
            isActive: isActive,
            linkedAccountId: linkedAccountId,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> merchantName = const Value.absent(),
            required int amountPaisa,
            required BillFrequencyDb frequency,
            required DateTime nextDueDate,
            Value<int> reminderDaysBefore = const Value.absent(),
            Value<bool> isAutoDetected = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> linkedAccountId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BillRemindersCompanion.insert(
            id: id,
            name: name,
            merchantName: merchantName,
            amountPaisa: amountPaisa,
            frequency: frequency,
            nextDueDate: nextDueDate,
            reminderDaysBefore: reminderDaysBefore,
            isAutoDetected: isAutoDetected,
            isActive: isActive,
            linkedAccountId: linkedAccountId,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BillRemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillRemindersTable,
    BillReminderRow,
    $$BillRemindersTableFilterComposer,
    $$BillRemindersTableOrderingComposer,
    $$BillRemindersTableAnnotationComposer,
    $$BillRemindersTableCreateCompanionBuilder,
    $$BillRemindersTableUpdateCompanionBuilder,
    (
      BillReminderRow,
      BaseReferences<_$AppDatabase, $BillRemindersTable, BillReminderRow>
    ),
    BillReminderRow,
    PrefetchHooks Function()>;
typedef $$BillPaymentsTableCreateCompanionBuilder = BillPaymentsCompanion
    Function({
  required String id,
  required String billId,
  required int amountPaisa,
  required DateTime paidAt,
  Value<String?> transactionId,
  Value<bool> isAutoLinked,
  Value<int> rowid,
});
typedef $$BillPaymentsTableUpdateCompanionBuilder = BillPaymentsCompanion
    Function({
  Value<String> id,
  Value<String> billId,
  Value<int> amountPaisa,
  Value<DateTime> paidAt,
  Value<String?> transactionId,
  Value<bool> isAutoLinked,
  Value<int> rowid,
});

class $$BillPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $BillPaymentsTable> {
  $$BillPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billId => $composableBuilder(
      column: $table.billId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAutoLinked => $composableBuilder(
      column: $table.isAutoLinked, builder: (column) => ColumnFilters(column));
}

class $$BillPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillPaymentsTable> {
  $$BillPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billId => $composableBuilder(
      column: $table.billId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAutoLinked => $composableBuilder(
      column: $table.isAutoLinked,
      builder: (column) => ColumnOrderings(column));
}

class $$BillPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillPaymentsTable> {
  $$BillPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get billId =>
      $composableBuilder(column: $table.billId, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<bool> get isAutoLinked => $composableBuilder(
      column: $table.isAutoLinked, builder: (column) => column);
}

class $$BillPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillPaymentsTable,
    BillPaymentRow,
    $$BillPaymentsTableFilterComposer,
    $$BillPaymentsTableOrderingComposer,
    $$BillPaymentsTableAnnotationComposer,
    $$BillPaymentsTableCreateCompanionBuilder,
    $$BillPaymentsTableUpdateCompanionBuilder,
    (
      BillPaymentRow,
      BaseReferences<_$AppDatabase, $BillPaymentsTable, BillPaymentRow>
    ),
    BillPaymentRow,
    PrefetchHooks Function()> {
  $$BillPaymentsTableTableManager(_$AppDatabase db, $BillPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> billId = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<DateTime> paidAt = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<bool> isAutoLinked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillPaymentsCompanion(
            id: id,
            billId: billId,
            amountPaisa: amountPaisa,
            paidAt: paidAt,
            transactionId: transactionId,
            isAutoLinked: isAutoLinked,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String billId,
            required int amountPaisa,
            required DateTime paidAt,
            Value<String?> transactionId = const Value.absent(),
            Value<bool> isAutoLinked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillPaymentsCompanion.insert(
            id: id,
            billId: billId,
            amountPaisa: amountPaisa,
            paidAt: paidAt,
            transactionId: transactionId,
            isAutoLinked: isAutoLinked,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BillPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillPaymentsTable,
    BillPaymentRow,
    $$BillPaymentsTableFilterComposer,
    $$BillPaymentsTableOrderingComposer,
    $$BillPaymentsTableAnnotationComposer,
    $$BillPaymentsTableCreateCompanionBuilder,
    $$BillPaymentsTableUpdateCompanionBuilder,
    (
      BillPaymentRow,
      BaseReferences<_$AppDatabase, $BillPaymentsTable, BillPaymentRow>
    ),
    BillPaymentRow,
    PrefetchHooks Function()>;
typedef $$LoansTableCreateCompanionBuilder = LoansCompanion Function({
  required String id,
  required String name,
  required LoanTypeDb type,
  required int principalPaisa,
  required int outstandingPaisa,
  required double interestRatePercent,
  required int emiPaisa,
  required int tenureMonths,
  Value<int> totalPaidPaisa,
  required DateTime startDate,
  Value<DateTime?> nextDueDate,
  Value<DateTime?> lastPaymentDate,
  Value<String?> lenderName,
  Value<bool> isActive,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$LoansTableUpdateCompanionBuilder = LoansCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<LoanTypeDb> type,
  Value<int> principalPaisa,
  Value<int> outstandingPaisa,
  Value<double> interestRatePercent,
  Value<int> emiPaisa,
  Value<int> tenureMonths,
  Value<int> totalPaidPaisa,
  Value<DateTime> startDate,
  Value<DateTime?> nextDueDate,
  Value<DateTime?> lastPaymentDate,
  Value<String?> lenderName,
  Value<bool> isActive,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LoansTableFilterComposer extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<LoanTypeDb, LoanTypeDb, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get principalPaisa => $composableBuilder(
      column: $table.principalPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get outstandingPaisa => $composableBuilder(
      column: $table.outstandingPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestRatePercent => $composableBuilder(
      column: $table.interestRatePercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get emiPaisa => $composableBuilder(
      column: $table.emiPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenureMonths => $composableBuilder(
      column: $table.tenureMonths, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalPaidPaisa => $composableBuilder(
      column: $table.totalPaidPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPaymentDate => $composableBuilder(
      column: $table.lastPaymentDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lenderName => $composableBuilder(
      column: $table.lenderName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LoansTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get principalPaisa => $composableBuilder(
      column: $table.principalPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get outstandingPaisa => $composableBuilder(
      column: $table.outstandingPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestRatePercent => $composableBuilder(
      column: $table.interestRatePercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get emiPaisa => $composableBuilder(
      column: $table.emiPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenureMonths => $composableBuilder(
      column: $table.tenureMonths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalPaidPaisa => $composableBuilder(
      column: $table.totalPaidPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPaymentDate => $composableBuilder(
      column: $table.lastPaymentDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lenderName => $composableBuilder(
      column: $table.lenderName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LoanTypeDb, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get principalPaisa => $composableBuilder(
      column: $table.principalPaisa, builder: (column) => column);

  GeneratedColumn<int> get outstandingPaisa => $composableBuilder(
      column: $table.outstandingPaisa, builder: (column) => column);

  GeneratedColumn<double> get interestRatePercent => $composableBuilder(
      column: $table.interestRatePercent, builder: (column) => column);

  GeneratedColumn<int> get emiPaisa =>
      $composableBuilder(column: $table.emiPaisa, builder: (column) => column);

  GeneratedColumn<int> get tenureMonths => $composableBuilder(
      column: $table.tenureMonths, builder: (column) => column);

  GeneratedColumn<int> get totalPaidPaisa => $composableBuilder(
      column: $table.totalPaidPaisa, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPaymentDate => $composableBuilder(
      column: $table.lastPaymentDate, builder: (column) => column);

  GeneratedColumn<String> get lenderName => $composableBuilder(
      column: $table.lenderName, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LoansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoansTable,
    LoanRow,
    $$LoansTableFilterComposer,
    $$LoansTableOrderingComposer,
    $$LoansTableAnnotationComposer,
    $$LoansTableCreateCompanionBuilder,
    $$LoansTableUpdateCompanionBuilder,
    (LoanRow, BaseReferences<_$AppDatabase, $LoansTable, LoanRow>),
    LoanRow,
    PrefetchHooks Function()> {
  $$LoansTableTableManager(_$AppDatabase db, $LoansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<LoanTypeDb> type = const Value.absent(),
            Value<int> principalPaisa = const Value.absent(),
            Value<int> outstandingPaisa = const Value.absent(),
            Value<double> interestRatePercent = const Value.absent(),
            Value<int> emiPaisa = const Value.absent(),
            Value<int> tenureMonths = const Value.absent(),
            Value<int> totalPaidPaisa = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> nextDueDate = const Value.absent(),
            Value<DateTime?> lastPaymentDate = const Value.absent(),
            Value<String?> lenderName = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LoansCompanion(
            id: id,
            name: name,
            type: type,
            principalPaisa: principalPaisa,
            outstandingPaisa: outstandingPaisa,
            interestRatePercent: interestRatePercent,
            emiPaisa: emiPaisa,
            tenureMonths: tenureMonths,
            totalPaidPaisa: totalPaidPaisa,
            startDate: startDate,
            nextDueDate: nextDueDate,
            lastPaymentDate: lastPaymentDate,
            lenderName: lenderName,
            isActive: isActive,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required LoanTypeDb type,
            required int principalPaisa,
            required int outstandingPaisa,
            required double interestRatePercent,
            required int emiPaisa,
            required int tenureMonths,
            Value<int> totalPaidPaisa = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> nextDueDate = const Value.absent(),
            Value<DateTime?> lastPaymentDate = const Value.absent(),
            Value<String?> lenderName = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LoansCompanion.insert(
            id: id,
            name: name,
            type: type,
            principalPaisa: principalPaisa,
            outstandingPaisa: outstandingPaisa,
            interestRatePercent: interestRatePercent,
            emiPaisa: emiPaisa,
            tenureMonths: tenureMonths,
            totalPaidPaisa: totalPaidPaisa,
            startDate: startDate,
            nextDueDate: nextDueDate,
            lastPaymentDate: lastPaymentDate,
            lenderName: lenderName,
            isActive: isActive,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LoansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoansTable,
    LoanRow,
    $$LoansTableFilterComposer,
    $$LoansTableOrderingComposer,
    $$LoansTableAnnotationComposer,
    $$LoansTableCreateCompanionBuilder,
    $$LoansTableUpdateCompanionBuilder,
    (LoanRow, BaseReferences<_$AppDatabase, $LoansTable, LoanRow>),
    LoanRow,
    PrefetchHooks Function()>;
typedef $$LoanPaymentsTableCreateCompanionBuilder = LoanPaymentsCompanion
    Function({
  required String id,
  required String loanId,
  required int amountPaisa,
  required int principalPaidPaisa,
  required int interestPaidPaisa,
  required DateTime paidAt,
  Value<bool> isExtraPayment,
  Value<String?> transactionId,
  Value<int> rowid,
});
typedef $$LoanPaymentsTableUpdateCompanionBuilder = LoanPaymentsCompanion
    Function({
  Value<String> id,
  Value<String> loanId,
  Value<int> amountPaisa,
  Value<int> principalPaidPaisa,
  Value<int> interestPaidPaisa,
  Value<DateTime> paidAt,
  Value<bool> isExtraPayment,
  Value<String?> transactionId,
  Value<int> rowid,
});

class $$LoanPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get loanId => $composableBuilder(
      column: $table.loanId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get principalPaidPaisa => $composableBuilder(
      column: $table.principalPaidPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get interestPaidPaisa => $composableBuilder(
      column: $table.interestPaidPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isExtraPayment => $composableBuilder(
      column: $table.isExtraPayment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));
}

class $$LoanPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loanId => $composableBuilder(
      column: $table.loanId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get principalPaidPaisa => $composableBuilder(
      column: $table.principalPaidPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interestPaidPaisa => $composableBuilder(
      column: $table.interestPaidPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isExtraPayment => $composableBuilder(
      column: $table.isExtraPayment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));
}

class $$LoanPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get loanId =>
      $composableBuilder(column: $table.loanId, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => column);

  GeneratedColumn<int> get principalPaidPaisa => $composableBuilder(
      column: $table.principalPaidPaisa, builder: (column) => column);

  GeneratedColumn<int> get interestPaidPaisa => $composableBuilder(
      column: $table.interestPaidPaisa, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<bool> get isExtraPayment => $composableBuilder(
      column: $table.isExtraPayment, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);
}

class $$LoanPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoanPaymentsTable,
    LoanPaymentRow,
    $$LoanPaymentsTableFilterComposer,
    $$LoanPaymentsTableOrderingComposer,
    $$LoanPaymentsTableAnnotationComposer,
    $$LoanPaymentsTableCreateCompanionBuilder,
    $$LoanPaymentsTableUpdateCompanionBuilder,
    (
      LoanPaymentRow,
      BaseReferences<_$AppDatabase, $LoanPaymentsTable, LoanPaymentRow>
    ),
    LoanPaymentRow,
    PrefetchHooks Function()> {
  $$LoanPaymentsTableTableManager(_$AppDatabase db, $LoanPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> loanId = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<int> principalPaidPaisa = const Value.absent(),
            Value<int> interestPaidPaisa = const Value.absent(),
            Value<DateTime> paidAt = const Value.absent(),
            Value<bool> isExtraPayment = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LoanPaymentsCompanion(
            id: id,
            loanId: loanId,
            amountPaisa: amountPaisa,
            principalPaidPaisa: principalPaidPaisa,
            interestPaidPaisa: interestPaidPaisa,
            paidAt: paidAt,
            isExtraPayment: isExtraPayment,
            transactionId: transactionId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String loanId,
            required int amountPaisa,
            required int principalPaidPaisa,
            required int interestPaidPaisa,
            required DateTime paidAt,
            Value<bool> isExtraPayment = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LoanPaymentsCompanion.insert(
            id: id,
            loanId: loanId,
            amountPaisa: amountPaisa,
            principalPaidPaisa: principalPaidPaisa,
            interestPaidPaisa: interestPaidPaisa,
            paidAt: paidAt,
            isExtraPayment: isExtraPayment,
            transactionId: transactionId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LoanPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoanPaymentsTable,
    LoanPaymentRow,
    $$LoanPaymentsTableFilterComposer,
    $$LoanPaymentsTableOrderingComposer,
    $$LoanPaymentsTableAnnotationComposer,
    $$LoanPaymentsTableCreateCompanionBuilder,
    $$LoanPaymentsTableUpdateCompanionBuilder,
    (
      LoanPaymentRow,
      BaseReferences<_$AppDatabase, $LoanPaymentsTable, LoanPaymentRow>
    ),
    LoanPaymentRow,
    PrefetchHooks Function()>;
typedef $$CreditCardsTableCreateCompanionBuilder = CreditCardsCompanion
    Function({
  required String id,
  required String name,
  required String lastFourDigits,
  required int creditLimitPaisa,
  Value<int> currentOutstandingPaisa,
  required int dueDay,
  required int statementDay,
  required double interestRatePercent,
  Value<String?> bankName,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CreditCardsTableUpdateCompanionBuilder = CreditCardsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> lastFourDigits,
  Value<int> creditLimitPaisa,
  Value<int> currentOutstandingPaisa,
  Value<int> dueDay,
  Value<int> statementDay,
  Value<double> interestRatePercent,
  Value<String?> bankName,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CreditCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastFourDigits => $composableBuilder(
      column: $table.lastFourDigits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get creditLimitPaisa => $composableBuilder(
      column: $table.creditLimitPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentOutstandingPaisa => $composableBuilder(
      column: $table.currentOutstandingPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get statementDay => $composableBuilder(
      column: $table.statementDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestRatePercent => $composableBuilder(
      column: $table.interestRatePercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CreditCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastFourDigits => $composableBuilder(
      column: $table.lastFourDigits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get creditLimitPaisa => $composableBuilder(
      column: $table.creditLimitPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentOutstandingPaisa => $composableBuilder(
      column: $table.currentOutstandingPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get statementDay => $composableBuilder(
      column: $table.statementDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestRatePercent => $composableBuilder(
      column: $table.interestRatePercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CreditCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lastFourDigits => $composableBuilder(
      column: $table.lastFourDigits, builder: (column) => column);

  GeneratedColumn<int> get creditLimitPaisa => $composableBuilder(
      column: $table.creditLimitPaisa, builder: (column) => column);

  GeneratedColumn<int> get currentOutstandingPaisa => $composableBuilder(
      column: $table.currentOutstandingPaisa, builder: (column) => column);

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<int> get statementDay => $composableBuilder(
      column: $table.statementDay, builder: (column) => column);

  GeneratedColumn<double> get interestRatePercent => $composableBuilder(
      column: $table.interestRatePercent, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CreditCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CreditCardsTable,
    CreditCardRow,
    $$CreditCardsTableFilterComposer,
    $$CreditCardsTableOrderingComposer,
    $$CreditCardsTableAnnotationComposer,
    $$CreditCardsTableCreateCompanionBuilder,
    $$CreditCardsTableUpdateCompanionBuilder,
    (
      CreditCardRow,
      BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCardRow>
    ),
    CreditCardRow,
    PrefetchHooks Function()> {
  $$CreditCardsTableTableManager(_$AppDatabase db, $CreditCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> lastFourDigits = const Value.absent(),
            Value<int> creditLimitPaisa = const Value.absent(),
            Value<int> currentOutstandingPaisa = const Value.absent(),
            Value<int> dueDay = const Value.absent(),
            Value<int> statementDay = const Value.absent(),
            Value<double> interestRatePercent = const Value.absent(),
            Value<String?> bankName = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardsCompanion(
            id: id,
            name: name,
            lastFourDigits: lastFourDigits,
            creditLimitPaisa: creditLimitPaisa,
            currentOutstandingPaisa: currentOutstandingPaisa,
            dueDay: dueDay,
            statementDay: statementDay,
            interestRatePercent: interestRatePercent,
            bankName: bankName,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String lastFourDigits,
            required int creditLimitPaisa,
            Value<int> currentOutstandingPaisa = const Value.absent(),
            required int dueDay,
            required int statementDay,
            required double interestRatePercent,
            Value<String?> bankName = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardsCompanion.insert(
            id: id,
            name: name,
            lastFourDigits: lastFourDigits,
            creditLimitPaisa: creditLimitPaisa,
            currentOutstandingPaisa: currentOutstandingPaisa,
            dueDay: dueDay,
            statementDay: statementDay,
            interestRatePercent: interestRatePercent,
            bankName: bankName,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CreditCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CreditCardsTable,
    CreditCardRow,
    $$CreditCardsTableFilterComposer,
    $$CreditCardsTableOrderingComposer,
    $$CreditCardsTableAnnotationComposer,
    $$CreditCardsTableCreateCompanionBuilder,
    $$CreditCardsTableUpdateCompanionBuilder,
    (
      CreditCardRow,
      BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCardRow>
    ),
    CreditCardRow,
    PrefetchHooks Function()>;
typedef $$InvestmentsTableCreateCompanionBuilder = InvestmentsCompanion
    Function({
  required String id,
  required String name,
  required InvestmentTypeDb type,
  Value<String?> platformId,
  required int investedPaisa,
  required int currentValuePaisa,
  Value<double> units,
  Value<double?> avgBuyPrice,
  required DateTime startDate,
  Value<DateTime?> maturityDate,
  Value<double?> interestRate,
  Value<String?> symbol,
  Value<String?> isin,
  Value<bool> isSip,
  Value<int?> sipAmountPaisa,
  Value<int?> sipDay,
  required DateTime lastUpdated,
  Value<String?> notes,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$InvestmentsTableUpdateCompanionBuilder = InvestmentsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<InvestmentTypeDb> type,
  Value<String?> platformId,
  Value<int> investedPaisa,
  Value<int> currentValuePaisa,
  Value<double> units,
  Value<double?> avgBuyPrice,
  Value<DateTime> startDate,
  Value<DateTime?> maturityDate,
  Value<double?> interestRate,
  Value<String?> symbol,
  Value<String?> isin,
  Value<bool> isSip,
  Value<int?> sipAmountPaisa,
  Value<int?> sipDay,
  Value<DateTime> lastUpdated,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$InvestmentsTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<InvestmentTypeDb, InvestmentTypeDb, int>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get platformId => $composableBuilder(
      column: $table.platformId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get investedPaisa => $composableBuilder(
      column: $table.investedPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentValuePaisa => $composableBuilder(
      column: $table.currentValuePaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgBuyPrice => $composableBuilder(
      column: $table.avgBuyPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get maturityDate => $composableBuilder(
      column: $table.maturityDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get isin => $composableBuilder(
      column: $table.isin, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSip => $composableBuilder(
      column: $table.isSip, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sipAmountPaisa => $composableBuilder(
      column: $table.sipAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sipDay => $composableBuilder(
      column: $table.sipDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$InvestmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get platformId => $composableBuilder(
      column: $table.platformId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get investedPaisa => $composableBuilder(
      column: $table.investedPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentValuePaisa => $composableBuilder(
      column: $table.currentValuePaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgBuyPrice => $composableBuilder(
      column: $table.avgBuyPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get maturityDate => $composableBuilder(
      column: $table.maturityDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestRate => $composableBuilder(
      column: $table.interestRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get isin => $composableBuilder(
      column: $table.isin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSip => $composableBuilder(
      column: $table.isSip, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sipAmountPaisa => $composableBuilder(
      column: $table.sipAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sipDay => $composableBuilder(
      column: $table.sipDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$InvestmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InvestmentTypeDb, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get platformId => $composableBuilder(
      column: $table.platformId, builder: (column) => column);

  GeneratedColumn<int> get investedPaisa => $composableBuilder(
      column: $table.investedPaisa, builder: (column) => column);

  GeneratedColumn<int> get currentValuePaisa => $composableBuilder(
      column: $table.currentValuePaisa, builder: (column) => column);

  GeneratedColumn<double> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<double> get avgBuyPrice => $composableBuilder(
      column: $table.avgBuyPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get maturityDate => $composableBuilder(
      column: $table.maturityDate, builder: (column) => column);

  GeneratedColumn<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get isin =>
      $composableBuilder(column: $table.isin, builder: (column) => column);

  GeneratedColumn<bool> get isSip =>
      $composableBuilder(column: $table.isSip, builder: (column) => column);

  GeneratedColumn<int> get sipAmountPaisa => $composableBuilder(
      column: $table.sipAmountPaisa, builder: (column) => column);

  GeneratedColumn<int> get sipDay =>
      $composableBuilder(column: $table.sipDay, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InvestmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvestmentsTable,
    InvestmentRow,
    $$InvestmentsTableFilterComposer,
    $$InvestmentsTableOrderingComposer,
    $$InvestmentsTableAnnotationComposer,
    $$InvestmentsTableCreateCompanionBuilder,
    $$InvestmentsTableUpdateCompanionBuilder,
    (
      InvestmentRow,
      BaseReferences<_$AppDatabase, $InvestmentsTable, InvestmentRow>
    ),
    InvestmentRow,
    PrefetchHooks Function()> {
  $$InvestmentsTableTableManager(_$AppDatabase db, $InvestmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<InvestmentTypeDb> type = const Value.absent(),
            Value<String?> platformId = const Value.absent(),
            Value<int> investedPaisa = const Value.absent(),
            Value<int> currentValuePaisa = const Value.absent(),
            Value<double> units = const Value.absent(),
            Value<double?> avgBuyPrice = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> maturityDate = const Value.absent(),
            Value<double?> interestRate = const Value.absent(),
            Value<String?> symbol = const Value.absent(),
            Value<String?> isin = const Value.absent(),
            Value<bool> isSip = const Value.absent(),
            Value<int?> sipAmountPaisa = const Value.absent(),
            Value<int?> sipDay = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentsCompanion(
            id: id,
            name: name,
            type: type,
            platformId: platformId,
            investedPaisa: investedPaisa,
            currentValuePaisa: currentValuePaisa,
            units: units,
            avgBuyPrice: avgBuyPrice,
            startDate: startDate,
            maturityDate: maturityDate,
            interestRate: interestRate,
            symbol: symbol,
            isin: isin,
            isSip: isSip,
            sipAmountPaisa: sipAmountPaisa,
            sipDay: sipDay,
            lastUpdated: lastUpdated,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required InvestmentTypeDb type,
            Value<String?> platformId = const Value.absent(),
            required int investedPaisa,
            required int currentValuePaisa,
            Value<double> units = const Value.absent(),
            Value<double?> avgBuyPrice = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> maturityDate = const Value.absent(),
            Value<double?> interestRate = const Value.absent(),
            Value<String?> symbol = const Value.absent(),
            Value<String?> isin = const Value.absent(),
            Value<bool> isSip = const Value.absent(),
            Value<int?> sipAmountPaisa = const Value.absent(),
            Value<int?> sipDay = const Value.absent(),
            required DateTime lastUpdated,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentsCompanion.insert(
            id: id,
            name: name,
            type: type,
            platformId: platformId,
            investedPaisa: investedPaisa,
            currentValuePaisa: currentValuePaisa,
            units: units,
            avgBuyPrice: avgBuyPrice,
            startDate: startDate,
            maturityDate: maturityDate,
            interestRate: interestRate,
            symbol: symbol,
            isin: isin,
            isSip: isSip,
            sipAmountPaisa: sipAmountPaisa,
            sipDay: sipDay,
            lastUpdated: lastUpdated,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InvestmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InvestmentsTable,
    InvestmentRow,
    $$InvestmentsTableFilterComposer,
    $$InvestmentsTableOrderingComposer,
    $$InvestmentsTableAnnotationComposer,
    $$InvestmentsTableCreateCompanionBuilder,
    $$InvestmentsTableUpdateCompanionBuilder,
    (
      InvestmentRow,
      BaseReferences<_$AppDatabase, $InvestmentsTable, InvestmentRow>
    ),
    InvestmentRow,
    PrefetchHooks Function()>;
typedef $$InvestmentTransactionsTableCreateCompanionBuilder
    = InvestmentTransactionsCompanion Function({
  required String id,
  required String investmentId,
  required InvestmentTransactionTypeDb type,
  required int amountPaisa,
  required double units,
  required double pricePerUnit,
  required DateTime transactionDate,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$InvestmentTransactionsTableUpdateCompanionBuilder
    = InvestmentTransactionsCompanion Function({
  Value<String> id,
  Value<String> investmentId,
  Value<InvestmentTransactionTypeDb> type,
  Value<int> amountPaisa,
  Value<double> units,
  Value<double> pricePerUnit,
  Value<DateTime> transactionDate,
  Value<String?> notes,
  Value<int> rowid,
});

class $$InvestmentTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentTransactionsTable> {
  $$InvestmentTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get investmentId => $composableBuilder(
      column: $table.investmentId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<InvestmentTransactionTypeDb,
          InvestmentTransactionTypeDb, int>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$InvestmentTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentTransactionsTable> {
  $$InvestmentTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get investmentId => $composableBuilder(
      column: $table.investmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$InvestmentTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentTransactionsTable> {
  $$InvestmentTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get investmentId => $composableBuilder(
      column: $table.investmentId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InvestmentTransactionTypeDb, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => column);

  GeneratedColumn<double> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$InvestmentTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvestmentTransactionsTable,
    InvestmentTransactionRow,
    $$InvestmentTransactionsTableFilterComposer,
    $$InvestmentTransactionsTableOrderingComposer,
    $$InvestmentTransactionsTableAnnotationComposer,
    $$InvestmentTransactionsTableCreateCompanionBuilder,
    $$InvestmentTransactionsTableUpdateCompanionBuilder,
    (
      InvestmentTransactionRow,
      BaseReferences<_$AppDatabase, $InvestmentTransactionsTable,
          InvestmentTransactionRow>
    ),
    InvestmentTransactionRow,
    PrefetchHooks Function()> {
  $$InvestmentTransactionsTableTableManager(
      _$AppDatabase db, $InvestmentTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentTransactionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentTransactionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> investmentId = const Value.absent(),
            Value<InvestmentTransactionTypeDb> type = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<double> units = const Value.absent(),
            Value<double> pricePerUnit = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentTransactionsCompanion(
            id: id,
            investmentId: investmentId,
            type: type,
            amountPaisa: amountPaisa,
            units: units,
            pricePerUnit: pricePerUnit,
            transactionDate: transactionDate,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String investmentId,
            required InvestmentTransactionTypeDb type,
            required int amountPaisa,
            required double units,
            required double pricePerUnit,
            required DateTime transactionDate,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentTransactionsCompanion.insert(
            id: id,
            investmentId: investmentId,
            type: type,
            amountPaisa: amountPaisa,
            units: units,
            pricePerUnit: pricePerUnit,
            transactionDate: transactionDate,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InvestmentTransactionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $InvestmentTransactionsTable,
        InvestmentTransactionRow,
        $$InvestmentTransactionsTableFilterComposer,
        $$InvestmentTransactionsTableOrderingComposer,
        $$InvestmentTransactionsTableAnnotationComposer,
        $$InvestmentTransactionsTableCreateCompanionBuilder,
        $$InvestmentTransactionsTableUpdateCompanionBuilder,
        (
          InvestmentTransactionRow,
          BaseReferences<_$AppDatabase, $InvestmentTransactionsTable,
              InvestmentTransactionRow>
        ),
        InvestmentTransactionRow,
        PrefetchHooks Function()>;
typedef $$FriendsTableCreateCompanionBuilder = FriendsCompanion Function({
  required String id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> avatarUrl,
  Value<int> totalOwedPaisa,
  Value<int> totalOwingPaisa,
  Value<DateTime?> lastActivityAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$FriendsTableUpdateCompanionBuilder = FriendsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> avatarUrl,
  Value<int> totalOwedPaisa,
  Value<int> totalOwingPaisa,
  Value<DateTime?> lastActivityAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FriendsTableFilterComposer
    extends Composer<_$AppDatabase, $FriendsTable> {
  $$FriendsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalOwedPaisa => $composableBuilder(
      column: $table.totalOwedPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalOwingPaisa => $composableBuilder(
      column: $table.totalOwingPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FriendsTableOrderingComposer
    extends Composer<_$AppDatabase, $FriendsTable> {
  $$FriendsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalOwedPaisa => $composableBuilder(
      column: $table.totalOwedPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalOwingPaisa => $composableBuilder(
      column: $table.totalOwingPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FriendsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FriendsTable> {
  $$FriendsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<int> get totalOwedPaisa => $composableBuilder(
      column: $table.totalOwedPaisa, builder: (column) => column);

  GeneratedColumn<int> get totalOwingPaisa => $composableBuilder(
      column: $table.totalOwingPaisa, builder: (column) => column);

  GeneratedColumn<DateTime> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FriendsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FriendsTable,
    FriendRow,
    $$FriendsTableFilterComposer,
    $$FriendsTableOrderingComposer,
    $$FriendsTableAnnotationComposer,
    $$FriendsTableCreateCompanionBuilder,
    $$FriendsTableUpdateCompanionBuilder,
    (FriendRow, BaseReferences<_$AppDatabase, $FriendsTable, FriendRow>),
    FriendRow,
    PrefetchHooks Function()> {
  $$FriendsTableTableManager(_$AppDatabase db, $FriendsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FriendsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FriendsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FriendsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<int> totalOwedPaisa = const Value.absent(),
            Value<int> totalOwingPaisa = const Value.absent(),
            Value<DateTime?> lastActivityAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FriendsCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            avatarUrl: avatarUrl,
            totalOwedPaisa: totalOwedPaisa,
            totalOwingPaisa: totalOwingPaisa,
            lastActivityAt: lastActivityAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<int> totalOwedPaisa = const Value.absent(),
            Value<int> totalOwingPaisa = const Value.absent(),
            Value<DateTime?> lastActivityAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FriendsCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            avatarUrl: avatarUrl,
            totalOwedPaisa: totalOwedPaisa,
            totalOwingPaisa: totalOwingPaisa,
            lastActivityAt: lastActivityAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FriendsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FriendsTable,
    FriendRow,
    $$FriendsTableFilterComposer,
    $$FriendsTableOrderingComposer,
    $$FriendsTableAnnotationComposer,
    $$FriendsTableCreateCompanionBuilder,
    $$FriendsTableUpdateCompanionBuilder,
    (FriendRow, BaseReferences<_$AppDatabase, $FriendsTable, FriendRow>),
    FriendRow,
    PrefetchHooks Function()>;
typedef $$ExpenseGroupsTableCreateCompanionBuilder = ExpenseGroupsCompanion
    Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<String?> iconCodePoint,
  Value<int?> colorValue,
  Value<String> memberIds,
  Value<int> totalExpensesPaisa,
  Value<DateTime?> lastActivityAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ExpenseGroupsTableUpdateCompanionBuilder = ExpenseGroupsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> iconCodePoint,
  Value<int?> colorValue,
  Value<String> memberIds,
  Value<int> totalExpensesPaisa,
  Value<DateTime?> lastActivityAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ExpenseGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseGroupsTable> {
  $$ExpenseGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memberIds => $composableBuilder(
      column: $table.memberIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalExpensesPaisa => $composableBuilder(
      column: $table.totalExpensesPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ExpenseGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseGroupsTable> {
  $$ExpenseGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memberIds => $composableBuilder(
      column: $table.memberIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalExpensesPaisa => $composableBuilder(
      column: $table.totalExpensesPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseGroupsTable> {
  $$ExpenseGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<String> get memberIds =>
      $composableBuilder(column: $table.memberIds, builder: (column) => column);

  GeneratedColumn<int> get totalExpensesPaisa => $composableBuilder(
      column: $table.totalExpensesPaisa, builder: (column) => column);

  GeneratedColumn<DateTime> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExpenseGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseGroupsTable,
    ExpenseGroupRow,
    $$ExpenseGroupsTableFilterComposer,
    $$ExpenseGroupsTableOrderingComposer,
    $$ExpenseGroupsTableAnnotationComposer,
    $$ExpenseGroupsTableCreateCompanionBuilder,
    $$ExpenseGroupsTableUpdateCompanionBuilder,
    (
      ExpenseGroupRow,
      BaseReferences<_$AppDatabase, $ExpenseGroupsTable, ExpenseGroupRow>
    ),
    ExpenseGroupRow,
    PrefetchHooks Function()> {
  $$ExpenseGroupsTableTableManager(_$AppDatabase db, $ExpenseGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> iconCodePoint = const Value.absent(),
            Value<int?> colorValue = const Value.absent(),
            Value<String> memberIds = const Value.absent(),
            Value<int> totalExpensesPaisa = const Value.absent(),
            Value<DateTime?> lastActivityAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseGroupsCompanion(
            id: id,
            name: name,
            description: description,
            iconCodePoint: iconCodePoint,
            colorValue: colorValue,
            memberIds: memberIds,
            totalExpensesPaisa: totalExpensesPaisa,
            lastActivityAt: lastActivityAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> iconCodePoint = const Value.absent(),
            Value<int?> colorValue = const Value.absent(),
            Value<String> memberIds = const Value.absent(),
            Value<int> totalExpensesPaisa = const Value.absent(),
            Value<DateTime?> lastActivityAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseGroupsCompanion.insert(
            id: id,
            name: name,
            description: description,
            iconCodePoint: iconCodePoint,
            colorValue: colorValue,
            memberIds: memberIds,
            totalExpensesPaisa: totalExpensesPaisa,
            lastActivityAt: lastActivityAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpenseGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseGroupsTable,
    ExpenseGroupRow,
    $$ExpenseGroupsTableFilterComposer,
    $$ExpenseGroupsTableOrderingComposer,
    $$ExpenseGroupsTableAnnotationComposer,
    $$ExpenseGroupsTableCreateCompanionBuilder,
    $$ExpenseGroupsTableUpdateCompanionBuilder,
    (
      ExpenseGroupRow,
      BaseReferences<_$AppDatabase, $ExpenseGroupsTable, ExpenseGroupRow>
    ),
    ExpenseGroupRow,
    PrefetchHooks Function()>;
typedef $$SharedExpensesTableCreateCompanionBuilder = SharedExpensesCompanion
    Function({
  required String id,
  Value<String?> transactionId,
  Value<String?> groupId,
  required String description,
  required int totalAmountPaisa,
  required String paidById,
  required SplitTypeDb splitType,
  required String participantsJson,
  required SettlementStatusDb status,
  Value<String?> notes,
  required DateTime expenseDate,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SharedExpensesTableUpdateCompanionBuilder = SharedExpensesCompanion
    Function({
  Value<String> id,
  Value<String?> transactionId,
  Value<String?> groupId,
  Value<String> description,
  Value<int> totalAmountPaisa,
  Value<String> paidById,
  Value<SplitTypeDb> splitType,
  Value<String> participantsJson,
  Value<SettlementStatusDb> status,
  Value<String?> notes,
  Value<DateTime> expenseDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SharedExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $SharedExpensesTable> {
  $$SharedExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalAmountPaisa => $composableBuilder(
      column: $table.totalAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paidById => $composableBuilder(
      column: $table.paidById, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SplitTypeDb, SplitTypeDb, int> get splitType =>
      $composableBuilder(
          column: $table.splitType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get participantsJson => $composableBuilder(
      column: $table.participantsJson,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SettlementStatusDb, SettlementStatusDb, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SharedExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $SharedExpensesTable> {
  $$SharedExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalAmountPaisa => $composableBuilder(
      column: $table.totalAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paidById => $composableBuilder(
      column: $table.paidById, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get splitType => $composableBuilder(
      column: $table.splitType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get participantsJson => $composableBuilder(
      column: $table.participantsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SharedExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SharedExpensesTable> {
  $$SharedExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get totalAmountPaisa => $composableBuilder(
      column: $table.totalAmountPaisa, builder: (column) => column);

  GeneratedColumn<String> get paidById =>
      $composableBuilder(column: $table.paidById, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SplitTypeDb, int> get splitType =>
      $composableBuilder(column: $table.splitType, builder: (column) => column);

  GeneratedColumn<String> get participantsJson => $composableBuilder(
      column: $table.participantsJson, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SettlementStatusDb, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SharedExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SharedExpensesTable,
    SharedExpenseRow,
    $$SharedExpensesTableFilterComposer,
    $$SharedExpensesTableOrderingComposer,
    $$SharedExpensesTableAnnotationComposer,
    $$SharedExpensesTableCreateCompanionBuilder,
    $$SharedExpensesTableUpdateCompanionBuilder,
    (
      SharedExpenseRow,
      BaseReferences<_$AppDatabase, $SharedExpensesTable, SharedExpenseRow>
    ),
    SharedExpenseRow,
    PrefetchHooks Function()> {
  $$SharedExpensesTableTableManager(
      _$AppDatabase db, $SharedExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SharedExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SharedExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SharedExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> totalAmountPaisa = const Value.absent(),
            Value<String> paidById = const Value.absent(),
            Value<SplitTypeDb> splitType = const Value.absent(),
            Value<String> participantsJson = const Value.absent(),
            Value<SettlementStatusDb> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> expenseDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SharedExpensesCompanion(
            id: id,
            transactionId: transactionId,
            groupId: groupId,
            description: description,
            totalAmountPaisa: totalAmountPaisa,
            paidById: paidById,
            splitType: splitType,
            participantsJson: participantsJson,
            status: status,
            notes: notes,
            expenseDate: expenseDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> transactionId = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            required String description,
            required int totalAmountPaisa,
            required String paidById,
            required SplitTypeDb splitType,
            required String participantsJson,
            required SettlementStatusDb status,
            Value<String?> notes = const Value.absent(),
            required DateTime expenseDate,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SharedExpensesCompanion.insert(
            id: id,
            transactionId: transactionId,
            groupId: groupId,
            description: description,
            totalAmountPaisa: totalAmountPaisa,
            paidById: paidById,
            splitType: splitType,
            participantsJson: participantsJson,
            status: status,
            notes: notes,
            expenseDate: expenseDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SharedExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SharedExpensesTable,
    SharedExpenseRow,
    $$SharedExpensesTableFilterComposer,
    $$SharedExpensesTableOrderingComposer,
    $$SharedExpensesTableAnnotationComposer,
    $$SharedExpensesTableCreateCompanionBuilder,
    $$SharedExpensesTableUpdateCompanionBuilder,
    (
      SharedExpenseRow,
      BaseReferences<_$AppDatabase, $SharedExpensesTable, SharedExpenseRow>
    ),
    SharedExpenseRow,
    PrefetchHooks Function()>;
typedef $$SettlementsTableCreateCompanionBuilder = SettlementsCompanion
    Function({
  required String id,
  required String friendId,
  Value<String?> sharedExpenseId,
  required int amountPaisa,
  required bool isIncoming,
  Value<String?> notes,
  required DateTime settledAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SettlementsTableUpdateCompanionBuilder = SettlementsCompanion
    Function({
  Value<String> id,
  Value<String> friendId,
  Value<String?> sharedExpenseId,
  Value<int> amountPaisa,
  Value<bool> isIncoming,
  Value<String?> notes,
  Value<DateTime> settledAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SettlementsTableFilterComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get friendId => $composableBuilder(
      column: $table.friendId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sharedExpenseId => $composableBuilder(
      column: $table.sharedExpenseId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isIncoming => $composableBuilder(
      column: $table.isIncoming, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get settledAt => $composableBuilder(
      column: $table.settledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SettlementsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get friendId => $composableBuilder(
      column: $table.friendId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sharedExpenseId => $composableBuilder(
      column: $table.sharedExpenseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isIncoming => $composableBuilder(
      column: $table.isIncoming, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get settledAt => $composableBuilder(
      column: $table.settledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SettlementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get friendId =>
      $composableBuilder(column: $table.friendId, builder: (column) => column);

  GeneratedColumn<String> get sharedExpenseId => $composableBuilder(
      column: $table.sharedExpenseId, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => column);

  GeneratedColumn<bool> get isIncoming => $composableBuilder(
      column: $table.isIncoming, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get settledAt =>
      $composableBuilder(column: $table.settledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SettlementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettlementsTable,
    SettlementRow,
    $$SettlementsTableFilterComposer,
    $$SettlementsTableOrderingComposer,
    $$SettlementsTableAnnotationComposer,
    $$SettlementsTableCreateCompanionBuilder,
    $$SettlementsTableUpdateCompanionBuilder,
    (
      SettlementRow,
      BaseReferences<_$AppDatabase, $SettlementsTable, SettlementRow>
    ),
    SettlementRow,
    PrefetchHooks Function()> {
  $$SettlementsTableTableManager(_$AppDatabase db, $SettlementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettlementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> friendId = const Value.absent(),
            Value<String?> sharedExpenseId = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<bool> isIncoming = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> settledAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettlementsCompanion(
            id: id,
            friendId: friendId,
            sharedExpenseId: sharedExpenseId,
            amountPaisa: amountPaisa,
            isIncoming: isIncoming,
            notes: notes,
            settledAt: settledAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String friendId,
            Value<String?> sharedExpenseId = const Value.absent(),
            required int amountPaisa,
            required bool isIncoming,
            Value<String?> notes = const Value.absent(),
            required DateTime settledAt,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettlementsCompanion.insert(
            id: id,
            friendId: friendId,
            sharedExpenseId: sharedExpenseId,
            amountPaisa: amountPaisa,
            isIncoming: isIncoming,
            notes: notes,
            settledAt: settledAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettlementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettlementsTable,
    SettlementRow,
    $$SettlementsTableFilterComposer,
    $$SettlementsTableOrderingComposer,
    $$SettlementsTableAnnotationComposer,
    $$SettlementsTableCreateCompanionBuilder,
    $$SettlementsTableUpdateCompanionBuilder,
    (
      SettlementRow,
      BaseReferences<_$AppDatabase, $SettlementsTable, SettlementRow>
    ),
    SettlementRow,
    PrefetchHooks Function()>;
typedef $$CompletedLessonsTableCreateCompanionBuilder
    = CompletedLessonsCompanion Function({
  required String id,
  required String lessonId,
  required String topicId,
  Value<int?> quizScore,
  Value<int> timeSpentSeconds,
  required DateTime completedAt,
  Value<int> rowid,
});
typedef $$CompletedLessonsTableUpdateCompanionBuilder
    = CompletedLessonsCompanion Function({
  Value<String> id,
  Value<String> lessonId,
  Value<String> topicId,
  Value<int?> quizScore,
  Value<int> timeSpentSeconds,
  Value<DateTime> completedAt,
  Value<int> rowid,
});

class $$CompletedLessonsTableFilterComposer
    extends Composer<_$AppDatabase, $CompletedLessonsTable> {
  $$CompletedLessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quizScore => $composableBuilder(
      column: $table.quizScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$CompletedLessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletedLessonsTable> {
  $$CompletedLessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quizScore => $composableBuilder(
      column: $table.quizScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$CompletedLessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletedLessonsTable> {
  $$CompletedLessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<int> get quizScore =>
      $composableBuilder(column: $table.quizScore, builder: (column) => column);

  GeneratedColumn<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$CompletedLessonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CompletedLessonsTable,
    CompletedLessonRow,
    $$CompletedLessonsTableFilterComposer,
    $$CompletedLessonsTableOrderingComposer,
    $$CompletedLessonsTableAnnotationComposer,
    $$CompletedLessonsTableCreateCompanionBuilder,
    $$CompletedLessonsTableUpdateCompanionBuilder,
    (
      CompletedLessonRow,
      BaseReferences<_$AppDatabase, $CompletedLessonsTable, CompletedLessonRow>
    ),
    CompletedLessonRow,
    PrefetchHooks Function()> {
  $$CompletedLessonsTableTableManager(
      _$AppDatabase db, $CompletedLessonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletedLessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletedLessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletedLessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> topicId = const Value.absent(),
            Value<int?> quizScore = const Value.absent(),
            Value<int> timeSpentSeconds = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CompletedLessonsCompanion(
            id: id,
            lessonId: lessonId,
            topicId: topicId,
            quizScore: quizScore,
            timeSpentSeconds: timeSpentSeconds,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String lessonId,
            required String topicId,
            Value<int?> quizScore = const Value.absent(),
            Value<int> timeSpentSeconds = const Value.absent(),
            required DateTime completedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CompletedLessonsCompanion.insert(
            id: id,
            lessonId: lessonId,
            topicId: topicId,
            quizScore: quizScore,
            timeSpentSeconds: timeSpentSeconds,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CompletedLessonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CompletedLessonsTable,
    CompletedLessonRow,
    $$CompletedLessonsTableFilterComposer,
    $$CompletedLessonsTableOrderingComposer,
    $$CompletedLessonsTableAnnotationComposer,
    $$CompletedLessonsTableCreateCompanionBuilder,
    $$CompletedLessonsTableUpdateCompanionBuilder,
    (
      CompletedLessonRow,
      BaseReferences<_$AppDatabase, $CompletedLessonsTable, CompletedLessonRow>
    ),
    CompletedLessonRow,
    PrefetchHooks Function()>;
typedef $$ShownTipsTableCreateCompanionBuilder = ShownTipsCompanion Function({
  required String id,
  required String tipId,
  Value<bool> wasDismissed,
  Value<bool> wasSaved,
  Value<bool> wasActedOn,
  required DateTime shownAt,
  Value<int> rowid,
});
typedef $$ShownTipsTableUpdateCompanionBuilder = ShownTipsCompanion Function({
  Value<String> id,
  Value<String> tipId,
  Value<bool> wasDismissed,
  Value<bool> wasSaved,
  Value<bool> wasActedOn,
  Value<DateTime> shownAt,
  Value<int> rowid,
});

class $$ShownTipsTableFilterComposer
    extends Composer<_$AppDatabase, $ShownTipsTable> {
  $$ShownTipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipId => $composableBuilder(
      column: $table.tipId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasDismissed => $composableBuilder(
      column: $table.wasDismissed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasSaved => $composableBuilder(
      column: $table.wasSaved, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasActedOn => $composableBuilder(
      column: $table.wasActedOn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get shownAt => $composableBuilder(
      column: $table.shownAt, builder: (column) => ColumnFilters(column));
}

class $$ShownTipsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShownTipsTable> {
  $$ShownTipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipId => $composableBuilder(
      column: $table.tipId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasDismissed => $composableBuilder(
      column: $table.wasDismissed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasSaved => $composableBuilder(
      column: $table.wasSaved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasActedOn => $composableBuilder(
      column: $table.wasActedOn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get shownAt => $composableBuilder(
      column: $table.shownAt, builder: (column) => ColumnOrderings(column));
}

class $$ShownTipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShownTipsTable> {
  $$ShownTipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipId =>
      $composableBuilder(column: $table.tipId, builder: (column) => column);

  GeneratedColumn<bool> get wasDismissed => $composableBuilder(
      column: $table.wasDismissed, builder: (column) => column);

  GeneratedColumn<bool> get wasSaved =>
      $composableBuilder(column: $table.wasSaved, builder: (column) => column);

  GeneratedColumn<bool> get wasActedOn => $composableBuilder(
      column: $table.wasActedOn, builder: (column) => column);

  GeneratedColumn<DateTime> get shownAt =>
      $composableBuilder(column: $table.shownAt, builder: (column) => column);
}

class $$ShownTipsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShownTipsTable,
    ShownTipRow,
    $$ShownTipsTableFilterComposer,
    $$ShownTipsTableOrderingComposer,
    $$ShownTipsTableAnnotationComposer,
    $$ShownTipsTableCreateCompanionBuilder,
    $$ShownTipsTableUpdateCompanionBuilder,
    (ShownTipRow, BaseReferences<_$AppDatabase, $ShownTipsTable, ShownTipRow>),
    ShownTipRow,
    PrefetchHooks Function()> {
  $$ShownTipsTableTableManager(_$AppDatabase db, $ShownTipsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShownTipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShownTipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShownTipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tipId = const Value.absent(),
            Value<bool> wasDismissed = const Value.absent(),
            Value<bool> wasSaved = const Value.absent(),
            Value<bool> wasActedOn = const Value.absent(),
            Value<DateTime> shownAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShownTipsCompanion(
            id: id,
            tipId: tipId,
            wasDismissed: wasDismissed,
            wasSaved: wasSaved,
            wasActedOn: wasActedOn,
            shownAt: shownAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String tipId,
            Value<bool> wasDismissed = const Value.absent(),
            Value<bool> wasSaved = const Value.absent(),
            Value<bool> wasActedOn = const Value.absent(),
            required DateTime shownAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ShownTipsCompanion.insert(
            id: id,
            tipId: tipId,
            wasDismissed: wasDismissed,
            wasSaved: wasSaved,
            wasActedOn: wasActedOn,
            shownAt: shownAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ShownTipsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShownTipsTable,
    ShownTipRow,
    $$ShownTipsTableFilterComposer,
    $$ShownTipsTableOrderingComposer,
    $$ShownTipsTableAnnotationComposer,
    $$ShownTipsTableCreateCompanionBuilder,
    $$ShownTipsTableUpdateCompanionBuilder,
    (ShownTipRow, BaseReferences<_$AppDatabase, $ShownTipsTable, ShownTipRow>),
    ShownTipRow,
    PrefetchHooks Function()>;
typedef $$CreditScoresTableCreateCompanionBuilder = CreditScoresCompanion
    Function({
  required String id,
  required int score,
  required String source,
  Value<String?> factors,
  required DateTime fetchedAt,
  Value<int> rowid,
});
typedef $$CreditScoresTableUpdateCompanionBuilder = CreditScoresCompanion
    Function({
  Value<String> id,
  Value<int> score,
  Value<String> source,
  Value<String?> factors,
  Value<DateTime> fetchedAt,
  Value<int> rowid,
});

class $$CreditScoresTableFilterComposer
    extends Composer<_$AppDatabase, $CreditScoresTable> {
  $$CreditScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get factors => $composableBuilder(
      column: $table.factors, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));
}

class $$CreditScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditScoresTable> {
  $$CreditScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get factors => $composableBuilder(
      column: $table.factors, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));
}

class $$CreditScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditScoresTable> {
  $$CreditScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get factors =>
      $composableBuilder(column: $table.factors, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CreditScoresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CreditScoresTable,
    CreditScoreRow,
    $$CreditScoresTableFilterComposer,
    $$CreditScoresTableOrderingComposer,
    $$CreditScoresTableAnnotationComposer,
    $$CreditScoresTableCreateCompanionBuilder,
    $$CreditScoresTableUpdateCompanionBuilder,
    (
      CreditScoreRow,
      BaseReferences<_$AppDatabase, $CreditScoresTable, CreditScoreRow>
    ),
    CreditScoreRow,
    PrefetchHooks Function()> {
  $$CreditScoresTableTableManager(_$AppDatabase db, $CreditScoresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> factors = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditScoresCompanion(
            id: id,
            score: score,
            source: source,
            factors: factors,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int score,
            required String source,
            Value<String?> factors = const Value.absent(),
            required DateTime fetchedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditScoresCompanion.insert(
            id: id,
            score: score,
            source: source,
            factors: factors,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CreditScoresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CreditScoresTable,
    CreditScoreRow,
    $$CreditScoresTableFilterComposer,
    $$CreditScoresTableOrderingComposer,
    $$CreditScoresTableAnnotationComposer,
    $$CreditScoresTableCreateCompanionBuilder,
    $$CreditScoresTableUpdateCompanionBuilder,
    (
      CreditScoreRow,
      BaseReferences<_$AppDatabase, $CreditScoresTable, CreditScoreRow>
    ),
    CreditScoreRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$LinkedAccountsTableTableManager get linkedAccounts =>
      $$LinkedAccountsTableTableManager(_db, _db.linkedAccounts);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$CustomCategoriesTableTableManager get customCategories =>
      $$CustomCategoriesTableTableManager(_db, _db.customCategories);
  $$MerchantMappingsTableTableManager get merchantMappings =>
      $$MerchantMappingsTableTableManager(_db, _db.merchantMappings);
  $$RecurringPatternsTableTableManager get recurringPatterns =>
      $$RecurringPatternsTableTableManager(_db, _db.recurringPatterns);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$PrivacyReportsTableTableManager get privacyReports =>
      $$PrivacyReportsTableTableManager(_db, _db.privacyReports);
  $$BackupMetadataTableTableManager get backupMetadata =>
      $$BackupMetadataTableTableManager(_db, _db.backupMetadata);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$BalanceSnapshotsTableTableManager get balanceSnapshots =>
      $$BalanceSnapshotsTableTableManager(_db, _db.balanceSnapshots);
  $$BillRemindersTableTableManager get billReminders =>
      $$BillRemindersTableTableManager(_db, _db.billReminders);
  $$BillPaymentsTableTableManager get billPayments =>
      $$BillPaymentsTableTableManager(_db, _db.billPayments);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$LoanPaymentsTableTableManager get loanPayments =>
      $$LoanPaymentsTableTableManager(_db, _db.loanPayments);
  $$CreditCardsTableTableManager get creditCards =>
      $$CreditCardsTableTableManager(_db, _db.creditCards);
  $$InvestmentsTableTableManager get investments =>
      $$InvestmentsTableTableManager(_db, _db.investments);
  $$InvestmentTransactionsTableTableManager get investmentTransactions =>
      $$InvestmentTransactionsTableTableManager(
          _db, _db.investmentTransactions);
  $$FriendsTableTableManager get friends =>
      $$FriendsTableTableManager(_db, _db.friends);
  $$ExpenseGroupsTableTableManager get expenseGroups =>
      $$ExpenseGroupsTableTableManager(_db, _db.expenseGroups);
  $$SharedExpensesTableTableManager get sharedExpenses =>
      $$SharedExpensesTableTableManager(_db, _db.sharedExpenses);
  $$SettlementsTableTableManager get settlements =>
      $$SettlementsTableTableManager(_db, _db.settlements);
  $$CompletedLessonsTableTableManager get completedLessons =>
      $$CompletedLessonsTableTableManager(_db, _db.completedLessons);
  $$ShownTipsTableTableManager get shownTips =>
      $$ShownTipsTableTableManager(_db, _db.shownTips);
  $$CreditScoresTableTableManager get creditScores =>
      $$CreditScoresTableTableManager(_db, _db.creditScores);
}
