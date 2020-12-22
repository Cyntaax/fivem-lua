# ORM

### Methods
    - Model
    - Column
    - AutoMigrate

### Properties
    - ColumnType


#### ORM.Model(name, ModelOptions)

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| name | string | yes | The table name for this column
| ModelOptions | table(ModelOptions | no | Options for this model

ModelOptions
> To be determined

Example

```lua
local _MyTable = {
    ID = 0,
    SomeField = ""
}
ORM.Model("myTable")(_MyTable)
```

### ORM.Column(name, ColumnOptions)

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| name | string | yes| The property name to bind this column to
| ColumnOptions | table(`ColumnOptions`) | no | The options for this column

ColumnOptions

| Property      | Type | Required | Description |
| ----------- | ----------- | --- | --- |
| column_name      | string  |  yes  | The name of the column in the database
| type   | string      |  yes | The type of this column. See ColumnType
| primaryKey | boolean | no | Whether this column is the primary key
| json | boolean | no | Whether this column is actually json. Use with `ColumnType.TEXT()`. Data from this field will be parsed into a json object.
| default | any | no | The default value for this column
| autoIncrement | boolean | no | Sets the auto increment flag for this column

Example

```lua
local _MyTable = {
    ID = 0,
    SomeField = ""
}

ORM.Column("ID", {
    column_name = "id",
    primaryKey = true,
    autoIncrement = true,
    type = ORM.ColumnType.INT()
})(_MyTable)

ORM.Column("SomeField", {
    column_name = "some_field",
    type = ORM.ColumnType.TEXT()
})
```

#### ORM.AutoMigrate(models, cb)

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| models | array(Model) | yes | List of models to be migrated
| cb | function: void | yes | Callback function to run when the migration is complete

Example

```lua
ORM.AutoMigrate({MyTable.new(), User.new()}, function()
    print("Migrations complete!")
end)
```


## Model Methods
These methods become available on a class after using the `Model` decorator

- save(cb)
- findOne(cb, queryOptions)
- findAll(cb, queryOptions)

queryOptions

| Property      | Type | Required | Description |
| ----------- | ----------- | --- | --- |
| where | table | no | A table which describes the query parameters.
| readOnly | boolean | no | Whether the results of this query will modify the original table

Examples

```lua
User = setmetatable({}, User)
User.__call = function()
    return "User"
end
User.__index = User

function User.new(name)
    local _User = {
        ID = 0,
        Name = name or ""
    }
    ORM.Column("ID", {
        column_name = "id",
        primaryKey = true,
        autoIncrement = true,
        type = ORM.ColumnType.INT()
    })(_User)
    ORM.Column("Name", {
        column_name = "name",
        type = ORM.ColumnType.TEXT()
    })(_User)
    
    return setmetatable(_User, User)
end

function User:WhatsMyName()
    return self.Name
end

function CreateUser(name)
    local user = User.new(name)
    user.save(function()
        print("User was saved successfully")
    end)
end

function FindUser(name)
    local user = User.new()
    user.findOne(function()
        print("Found a user!", user.Name)
    end, { name = name })
end

function GetAllUsers()
    local user = User.new()
    user.findAll(function(users)
        for k,v in pairs(users) do
            print(v:WhatsMyName())
        end
    end)
end

```
