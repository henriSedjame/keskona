import 'package:keskona/models/Item.dart';
import 'package:keskona/repository/utils/queries.dart';
import 'package:postgres/postgres.dart';

class ItemRepository {
  late final PostgreSQLConnection _connection;

  ItemRepository(this._connection);

  Future<void> init() async {
    await _connection.open();
    await _connection.query(addUuidExtensionQuery);
    await _connection.query(createTableQuery);
  }

  Future<Item> addItem(Item item) async {

    var result = await _connection.query(insertQuery, substitutionValues: {
      idParam: item.id,
      labelParam: item.label,
      qtyParam: item.quantity,
      positionParam: item.position,
      dateParam: item.date,
      categoryParam: item.category?.name,
      infoParam: item.info
    });

    return Item.fromJson(result.first.toColumnMap());
  }

  Future<List<Item>?> findAll() async {
    var result = await _connection.query(findAllQuery);
    return result
        .map((row) => Item.fromJson(row.toColumnMap()))
        .toList();
  }

  Future<bool> updateQty(String id, int quantity) async {
    if (quantity == 0) {
      return await delete(id);
    }

    var result = await _connection
        .query(updateQtyQuery, substitutionValues: {qtyParam: quantity, idParam: id});

    return result.affectedRowCount == 1;
  }

  Future<bool> updatePos(String id, int pos) async {

    var result = await _connection
        .query(updatePosQuery, substitutionValues: {positionParam: pos, idParam: id});

    return result.affectedRowCount == 1;
  }

  Future<bool> delete(String id) async {
    var result =
        await _connection.query(deleteQuery, substitutionValues: {idParam: id});

    return result.affectedRowCount == 1;
  }
}
