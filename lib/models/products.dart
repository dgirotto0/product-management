class Product {
  final String? filtro;
  final String? modelo;
  final double? valor;
  final String? correspondente;
  final String? tipo;
  final String? numero;
  final String? cod;
  final String? especificacao;
  final String? oleo;
  final String? viscosidade;

  Product({
    this.filtro,
    this.modelo,
    this.valor,
    this.correspondente,
    this.tipo,
    this.numero,
    this.cod,
    this.especificacao,
    this.oleo,
    this.viscosidade,
  });

  factory Product.fromMap(Map<String, dynamic> map, List<String> columns) {
    return Product(
      filtro: columns.contains('filtro') ? map['filtro'] as String? : '',
      modelo: columns.contains('modelo') ? map['modelo'] as String? : '',
      valor: columns.contains('valor') ? (map['valor'] as num?)?.toDouble() : null,
      correspondente: columns.contains('correspondente') ? map['correspondente'] as String? : ' ',
      tipo: columns.contains('tipo') ? map['tipo'] as String? : '',
      numero: columns.contains('numero') ? map['numero'] as String? : '',
      cod: columns.contains('cod') ? map['cod'] as String? : '',
      especificacao: columns.contains('especificacao') ? map['especificacao'] as String? : '',
      oleo: columns.contains('oleo') ? map['oleo'] as String? : '',
      viscosidade: columns.contains('viscosidade') ? map['viscosidade'] as String? : '',
    );
  }

  Map<String, dynamic> toMap(List<String> columns) {
    final map = <String, dynamic>{};
    if (columns.contains('filtro')) map['filtro'] = filtro;
    if (columns.contains('modelo')) map['modelo'] = modelo;
    if (columns.contains('valor')) map['valor'] = valor;
    if (columns.contains('correspondente')) map['correspondente'] = correspondente;
    if (columns.contains('tipo')) map['tipo'] = tipo;
    if (columns.contains('numero')) map['numero'] = numero;
    if (columns.contains('cod')) map['cod'] = cod;
    if (columns.contains('especificacao')) map['especificacao'] = especificacao;
    if (columns.contains('oleo')) map['oleo'] = oleo;
    if (columns.contains('viscosidade')) map['viscosidade'] = viscosidade;
    return map;
  }
}
