// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, Producto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
    'precio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    descripcion,
    precio,
    stock,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Producto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Producto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Producto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class Producto extends DataClass implements Insertable<Producto> {
  final int id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int stock;
  final DateTime createdAt;
  const Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.stock,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['precio'] = Variable<double>(precio);
    map['stock'] = Variable<int>(stock);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      precio: Value(precio),
      stock: Value(stock),
      createdAt: Value(createdAt),
    );
  }

  factory Producto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Producto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      precio: serializer.fromJson<double>(json['precio']),
      stock: serializer.fromJson<int>(json['stock']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'precio': serializer.toJson<double>(precio),
      'stock': serializer.toJson<int>(stock),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Producto copyWith({
    int? id,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    double? precio,
    int? stock,
    DateTime? createdAt,
  }) => Producto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    precio: precio ?? this.precio,
    stock: stock ?? this.stock,
    createdAt: createdAt ?? this.createdAt,
  );
  Producto copyWithCompanion(ProductosCompanion data) {
    return Producto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      precio: data.precio.present ? data.precio.value : this.precio,
      stock: data.stock.present ? data.stock.value : this.stock,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Producto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precio: $precio, ')
          ..write('stock: $stock, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, descripcion, precio, stock, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Producto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.precio == this.precio &&
          other.stock == this.stock &&
          other.createdAt == this.createdAt);
}

class ProductosCompanion extends UpdateCompanion<Producto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<double> precio;
  final Value<int> stock;
  final Value<DateTime> createdAt;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.precio = const Value.absent(),
    this.stock = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    this.precio = const Value.absent(),
    this.stock = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Producto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<double>? precio,
    Expression<int>? stock,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (precio != null) 'precio': precio,
      if (stock != null) 'stock': stock,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<double>? precio,
    Value<int>? stock,
    Value<DateTime>? createdAt,
  }) {
    return ProductosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precio: $precio, ')
          ..write('stock: $stock, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TiposMuebleTable extends TiposMueble
    with TableInfo<$TiposMuebleTable, TiposMuebleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TiposMuebleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tipos_mueble';
  @override
  VerificationContext validateIntegrity(
    Insertable<TiposMuebleData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TiposMuebleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TiposMuebleData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $TiposMuebleTable createAlias(String alias) {
    return $TiposMuebleTable(attachedDatabase, alias);
  }
}

class TiposMuebleData extends DataClass implements Insertable<TiposMuebleData> {
  final int id;
  final String nombre;
  const TiposMuebleData({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  TiposMuebleCompanion toCompanion(bool nullToAbsent) {
    return TiposMuebleCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory TiposMuebleData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TiposMuebleData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  TiposMuebleData copyWith({int? id, String? nombre}) =>
      TiposMuebleData(id: id ?? this.id, nombre: nombre ?? this.nombre);
  TiposMuebleData copyWithCompanion(TiposMuebleCompanion data) {
    return TiposMuebleData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TiposMuebleData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TiposMuebleData &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class TiposMuebleCompanion extends UpdateCompanion<TiposMuebleData> {
  final Value<int> id;
  final Value<String> nombre;
  const TiposMuebleCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  TiposMuebleCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<TiposMuebleData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  TiposMuebleCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return TiposMuebleCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TiposMuebleCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $PresupuestosTable extends Presupuestos
    with TableInfo<$PresupuestosTable, Presupuesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresupuestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tipoMuebleIdMeta = const VerificationMeta(
    'tipoMuebleId',
  );
  @override
  late final GeneratedColumn<int> tipoMuebleId = GeneratedColumn<int>(
    'tipo_mueble_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tipos_mueble (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _precioTotalMeta = const VerificationMeta(
    'precioTotal',
  );
  @override
  late final GeneratedColumn<double> precioTotal = GeneratedColumn<double>(
    'precio_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipoMuebleId,
    nombre,
    descripcion,
    cantidad,
    precioUnitario,
    precioTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presupuestos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Presupuesto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo_mueble_id')) {
      context.handle(
        _tipoMuebleIdMeta,
        tipoMuebleId.isAcceptableOrUnknown(
          data['tipo_mueble_id']!,
          _tipoMuebleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoMuebleIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    }
    if (data.containsKey('precio_total')) {
      context.handle(
        _precioTotalMeta,
        precioTotal.isAcceptableOrUnknown(
          data['precio_total']!,
          _precioTotalMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Presupuesto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Presupuesto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipoMuebleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo_mueble_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      precioTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_total'],
      )!,
    );
  }

  @override
  $PresupuestosTable createAlias(String alias) {
    return $PresupuestosTable(attachedDatabase, alias);
  }
}

class Presupuesto extends DataClass implements Insertable<Presupuesto> {
  final int id;
  final int tipoMuebleId;
  final String nombre;
  final String? descripcion;
  final int cantidad;
  final double precioUnitario;
  final double precioTotal;
  const Presupuesto({
    required this.id,
    required this.tipoMuebleId,
    required this.nombre,
    this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    required this.precioTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo_mueble_id'] = Variable<int>(tipoMuebleId);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['precio_total'] = Variable<double>(precioTotal);
    return map;
  }

  PresupuestosCompanion toCompanion(bool nullToAbsent) {
    return PresupuestosCompanion(
      id: Value(id),
      tipoMuebleId: Value(tipoMuebleId),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
      precioTotal: Value(precioTotal),
    );
  }

  factory Presupuesto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Presupuesto(
      id: serializer.fromJson<int>(json['id']),
      tipoMuebleId: serializer.fromJson<int>(json['tipoMuebleId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      precioTotal: serializer.fromJson<double>(json['precioTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipoMuebleId': serializer.toJson<int>(tipoMuebleId),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'precioTotal': serializer.toJson<double>(precioTotal),
    };
  }

  Presupuesto copyWith({
    int? id,
    int? tipoMuebleId,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    int? cantidad,
    double? precioUnitario,
    double? precioTotal,
  }) => Presupuesto(
    id: id ?? this.id,
    tipoMuebleId: tipoMuebleId ?? this.tipoMuebleId,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    precioTotal: precioTotal ?? this.precioTotal,
  );
  Presupuesto copyWithCompanion(PresupuestosCompanion data) {
    return Presupuesto(
      id: data.id.present ? data.id.value : this.id,
      tipoMuebleId: data.tipoMuebleId.present
          ? data.tipoMuebleId.value
          : this.tipoMuebleId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      precioTotal: data.precioTotal.present
          ? data.precioTotal.value
          : this.precioTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Presupuesto(')
          ..write('id: $id, ')
          ..write('tipoMuebleId: $tipoMuebleId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('precioTotal: $precioTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipoMuebleId,
    nombre,
    descripcion,
    cantidad,
    precioUnitario,
    precioTotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Presupuesto &&
          other.id == this.id &&
          other.tipoMuebleId == this.tipoMuebleId &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.precioTotal == this.precioTotal);
}

class PresupuestosCompanion extends UpdateCompanion<Presupuesto> {
  final Value<int> id;
  final Value<int> tipoMuebleId;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<double> precioTotal;
  const PresupuestosCompanion({
    this.id = const Value.absent(),
    this.tipoMuebleId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.precioTotal = const Value.absent(),
  });
  PresupuestosCompanion.insert({
    this.id = const Value.absent(),
    required int tipoMuebleId,
    required String nombre,
    this.descripcion = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.precioTotal = const Value.absent(),
  }) : tipoMuebleId = Value(tipoMuebleId),
       nombre = Value(nombre);
  static Insertable<Presupuesto> custom({
    Expression<int>? id,
    Expression<int>? tipoMuebleId,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
    Expression<double>? precioTotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipoMuebleId != null) 'tipo_mueble_id': tipoMuebleId,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (precioTotal != null) 'precio_total': precioTotal,
    });
  }

  PresupuestosCompanion copyWith({
    Value<int>? id,
    Value<int>? tipoMuebleId,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<int>? cantidad,
    Value<double>? precioUnitario,
    Value<double>? precioTotal,
  }) {
    return PresupuestosCompanion(
      id: id ?? this.id,
      tipoMuebleId: tipoMuebleId ?? this.tipoMuebleId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      precioTotal: precioTotal ?? this.precioTotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipoMuebleId.present) {
      map['tipo_mueble_id'] = Variable<int>(tipoMuebleId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (precioTotal.present) {
      map['precio_total'] = Variable<double>(precioTotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresupuestosCompanion(')
          ..write('id: $id, ')
          ..write('tipoMuebleId: $tipoMuebleId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('precioTotal: $precioTotal')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $TiposMuebleTable tiposMueble = $TiposMuebleTable(this);
  late final $PresupuestosTable presupuestos = $PresupuestosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productos,
    tiposMueble,
    presupuestos,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tipos_mueble',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('presupuestos', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> descripcion,
      Value<double> precio,
      Value<int> stock,
      Value<DateTime> createdAt,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<double> precio,
      Value<int> stock,
      Value<DateTime> createdAt,
    });

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProductosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTable,
          Producto,
          $$ProductosTableFilterComposer,
          $$ProductosTableOrderingComposer,
          $$ProductosTableAnnotationComposer,
          $$ProductosTableCreateCompanionBuilder,
          $$ProductosTableUpdateCompanionBuilder,
          (Producto, BaseReferences<_$AppDatabase, $ProductosTable, Producto>),
          Producto,
          PrefetchHooks Function()
        > {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<double> precio = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductosCompanion(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                precio: precio,
                stock: stock,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                Value<double> precio = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductosCompanion.insert(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                precio: precio,
                stock: stock,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTable,
      Producto,
      $$ProductosTableFilterComposer,
      $$ProductosTableOrderingComposer,
      $$ProductosTableAnnotationComposer,
      $$ProductosTableCreateCompanionBuilder,
      $$ProductosTableUpdateCompanionBuilder,
      (Producto, BaseReferences<_$AppDatabase, $ProductosTable, Producto>),
      Producto,
      PrefetchHooks Function()
    >;
typedef $$TiposMuebleTableCreateCompanionBuilder =
    TiposMuebleCompanion Function({Value<int> id, required String nombre});
typedef $$TiposMuebleTableUpdateCompanionBuilder =
    TiposMuebleCompanion Function({Value<int> id, Value<String> nombre});

final class $$TiposMuebleTableReferences
    extends BaseReferences<_$AppDatabase, $TiposMuebleTable, TiposMuebleData> {
  $$TiposMuebleTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PresupuestosTable, List<Presupuesto>>
  _presupuestosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.presupuestos,
    aliasName: $_aliasNameGenerator(
      db.tiposMueble.id,
      db.presupuestos.tipoMuebleId,
    ),
  );

  $$PresupuestosTableProcessedTableManager get presupuestosRefs {
    final manager = $$PresupuestosTableTableManager(
      $_db,
      $_db.presupuestos,
    ).filter((f) => f.tipoMuebleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_presupuestosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TiposMuebleTableFilterComposer
    extends Composer<_$AppDatabase, $TiposMuebleTable> {
  $$TiposMuebleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> presupuestosRefs(
    Expression<bool> Function($$PresupuestosTableFilterComposer f) f,
  ) {
    final $$PresupuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.tipoMuebleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableFilterComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TiposMuebleTableOrderingComposer
    extends Composer<_$AppDatabase, $TiposMuebleTable> {
  $$TiposMuebleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TiposMuebleTableAnnotationComposer
    extends Composer<_$AppDatabase, $TiposMuebleTable> {
  $$TiposMuebleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  Expression<T> presupuestosRefs<T extends Object>(
    Expression<T> Function($$PresupuestosTableAnnotationComposer a) f,
  ) {
    final $$PresupuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.tipoMuebleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TiposMuebleTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TiposMuebleTable,
          TiposMuebleData,
          $$TiposMuebleTableFilterComposer,
          $$TiposMuebleTableOrderingComposer,
          $$TiposMuebleTableAnnotationComposer,
          $$TiposMuebleTableCreateCompanionBuilder,
          $$TiposMuebleTableUpdateCompanionBuilder,
          (TiposMuebleData, $$TiposMuebleTableReferences),
          TiposMuebleData,
          PrefetchHooks Function({bool presupuestosRefs})
        > {
  $$TiposMuebleTableTableManager(_$AppDatabase db, $TiposMuebleTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TiposMuebleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TiposMuebleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TiposMuebleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
              }) => TiposMuebleCompanion(id: id, nombre: nombre),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
              }) => TiposMuebleCompanion.insert(id: id, nombre: nombre),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TiposMuebleTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({presupuestosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (presupuestosRefs) db.presupuestos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (presupuestosRefs)
                    await $_getPrefetchedData<
                      TiposMuebleData,
                      $TiposMuebleTable,
                      Presupuesto
                    >(
                      currentTable: table,
                      referencedTable: $$TiposMuebleTableReferences
                          ._presupuestosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TiposMuebleTableReferences(
                            db,
                            table,
                            p0,
                          ).presupuestosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.tipoMuebleId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TiposMuebleTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TiposMuebleTable,
      TiposMuebleData,
      $$TiposMuebleTableFilterComposer,
      $$TiposMuebleTableOrderingComposer,
      $$TiposMuebleTableAnnotationComposer,
      $$TiposMuebleTableCreateCompanionBuilder,
      $$TiposMuebleTableUpdateCompanionBuilder,
      (TiposMuebleData, $$TiposMuebleTableReferences),
      TiposMuebleData,
      PrefetchHooks Function({bool presupuestosRefs})
    >;
typedef $$PresupuestosTableCreateCompanionBuilder =
    PresupuestosCompanion Function({
      Value<int> id,
      required int tipoMuebleId,
      required String nombre,
      Value<String?> descripcion,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<double> precioTotal,
    });
typedef $$PresupuestosTableUpdateCompanionBuilder =
    PresupuestosCompanion Function({
      Value<int> id,
      Value<int> tipoMuebleId,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<double> precioTotal,
    });

final class $$PresupuestosTableReferences
    extends BaseReferences<_$AppDatabase, $PresupuestosTable, Presupuesto> {
  $$PresupuestosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TiposMuebleTable _tipoMuebleIdTable(_$AppDatabase db) =>
      db.tiposMueble.createAlias(
        $_aliasNameGenerator(db.presupuestos.tipoMuebleId, db.tiposMueble.id),
      );

  $$TiposMuebleTableProcessedTableManager get tipoMuebleId {
    final $_column = $_itemColumn<int>('tipo_mueble_id')!;

    final manager = $$TiposMuebleTableTableManager(
      $_db,
      $_db.tiposMueble,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoMuebleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PresupuestosTableFilterComposer
    extends Composer<_$AppDatabase, $PresupuestosTable> {
  $$PresupuestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioTotal => $composableBuilder(
    column: $table.precioTotal,
    builder: (column) => ColumnFilters(column),
  );

  $$TiposMuebleTableFilterComposer get tipoMuebleId {
    final $$TiposMuebleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoMuebleId,
      referencedTable: $db.tiposMueble,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposMuebleTableFilterComposer(
            $db: $db,
            $table: $db.tiposMueble,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosTableOrderingComposer
    extends Composer<_$AppDatabase, $PresupuestosTable> {
  $$PresupuestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioTotal => $composableBuilder(
    column: $table.precioTotal,
    builder: (column) => ColumnOrderings(column),
  );

  $$TiposMuebleTableOrderingComposer get tipoMuebleId {
    final $$TiposMuebleTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoMuebleId,
      referencedTable: $db.tiposMueble,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposMuebleTableOrderingComposer(
            $db: $db,
            $table: $db.tiposMueble,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresupuestosTable> {
  $$PresupuestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioTotal => $composableBuilder(
    column: $table.precioTotal,
    builder: (column) => column,
  );

  $$TiposMuebleTableAnnotationComposer get tipoMuebleId {
    final $$TiposMuebleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoMuebleId,
      referencedTable: $db.tiposMueble,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TiposMuebleTableAnnotationComposer(
            $db: $db,
            $table: $db.tiposMueble,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresupuestosTable,
          Presupuesto,
          $$PresupuestosTableFilterComposer,
          $$PresupuestosTableOrderingComposer,
          $$PresupuestosTableAnnotationComposer,
          $$PresupuestosTableCreateCompanionBuilder,
          $$PresupuestosTableUpdateCompanionBuilder,
          (Presupuesto, $$PresupuestosTableReferences),
          Presupuesto,
          PrefetchHooks Function({bool tipoMuebleId})
        > {
  $$PresupuestosTableTableManager(_$AppDatabase db, $PresupuestosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresupuestosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresupuestosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresupuestosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tipoMuebleId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<double> precioTotal = const Value.absent(),
              }) => PresupuestosCompanion(
                id: id,
                tipoMuebleId: tipoMuebleId,
                nombre: nombre,
                descripcion: descripcion,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                precioTotal: precioTotal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tipoMuebleId,
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<double> precioTotal = const Value.absent(),
              }) => PresupuestosCompanion.insert(
                id: id,
                tipoMuebleId: tipoMuebleId,
                nombre: nombre,
                descripcion: descripcion,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                precioTotal: precioTotal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PresupuestosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tipoMuebleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tipoMuebleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tipoMuebleId,
                                referencedTable: $$PresupuestosTableReferences
                                    ._tipoMuebleIdTable(db),
                                referencedColumn: $$PresupuestosTableReferences
                                    ._tipoMuebleIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PresupuestosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresupuestosTable,
      Presupuesto,
      $$PresupuestosTableFilterComposer,
      $$PresupuestosTableOrderingComposer,
      $$PresupuestosTableAnnotationComposer,
      $$PresupuestosTableCreateCompanionBuilder,
      $$PresupuestosTableUpdateCompanionBuilder,
      (Presupuesto, $$PresupuestosTableReferences),
      Presupuesto,
      PrefetchHooks Function({bool tipoMuebleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
  $$TiposMuebleTableTableManager get tiposMueble =>
      $$TiposMuebleTableTableManager(_db, _db.tiposMueble);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db, _db.presupuestos);
}
