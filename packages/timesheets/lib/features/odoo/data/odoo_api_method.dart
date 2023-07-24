enum OdooApiMethod {
  read('read'),
  search('search'),
  searchRead('search_read'),
  fieldsGet('fields_get'),
  create('create'),
  write('write'),
  unlink('unlink'),
  onChange('onchange');

  const OdooApiMethod(this.name);

  final String name;
}
