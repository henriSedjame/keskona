const String idParam = "id";
const String labelParam = "label";
const String qtyParam = "quantity";
const String positionParam = "position";
const String dateParam = "date";
const String categoryParam = "category";
const String infoParam = "info";

const String addUuidExtensionQuery = "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"";

const String createTableQuery =
    "CREATE TABLE IF NOT EXISTS items ("
    " id uuid DEFAULT uuid_generate_v4() NOT NULL PRIMARY KEY,"
    " label VARCHAR(255) NOT NULL,"
    " quantity INT NOT NULL,"
    " position INT NOT NULL,"
    " date TIMESTAMP NOT NULL,"
    " category VARCHAR(255) NOT NULL,"
    " info VARCHAR(255)"
    ")";

const String findAllQuery =
    "SELECT * FROM items";

const String insertQuery  =
    "INSERT INTO items VALUES "
    "( @id, @label, @quantity, @position, @date, @category, @info) RETURNING *";

const String updateQuery =
    "UPDATE items SET"
    " quantity = @quantity"
    " WHERE id = @id";

const String deleteQuery =
    "DELETE FROM items WHERE id = @id";