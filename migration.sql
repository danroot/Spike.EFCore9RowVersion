IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
CREATE TABLE [Persons] (
    [Id] int NOT NULL IDENTITY,
    [FirstName] nvarchar(100) NOT NULL,
    [LastName] nvarchar(100) NOT NULL,
    CONSTRAINT [PK_Persons] PRIMARY KEY ([Id])
);

CREATE TABLE [Contacts] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(100) NOT NULL,
    [Email] nvarchar(100) NOT NULL,
    [Phone] nvarchar(20) NOT NULL,
    [PersonId] int NULL,
    CONSTRAINT [PK_Contacts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Contacts_Persons_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [Persons] ([Id])
);

CREATE INDEX [IX_Contacts_PersonId] ON [Contacts] ([PersonId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241204143951_InitialMigration', N'9.0.0');

ALTER TABLE [Persons] ADD [RowVersion] rowversion NOT NULL;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241204150135_RowVersion', N'9.0.0');

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Persons]') AND [c].[name] = N'RowVersion');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Persons] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [Persons] ALTER COLUMN [RowVersion] rowversion NOT NULL;

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Persons]') AND [c].[name] = N'LastName');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [Persons] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [Persons] ALTER COLUMN [LastName] nvarchar(100) NOT NULL;

DECLARE @var2 sysname;
SELECT @var2 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Persons]') AND [c].[name] = N'FirstName');
IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [Persons] DROP CONSTRAINT [' + @var2 + '];');
ALTER TABLE [Persons] ALTER COLUMN [FirstName] nvarchar(100) NOT NULL;

DECLARE @var3 sysname;
SELECT @var3 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Persons]') AND [c].[name] = N'Id');
IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [Persons] DROP CONSTRAINT [' + @var3 + '];');
ALTER TABLE [Persons] ALTER COLUMN [Id] int NOT NULL;

ALTER TABLE [Persons] ADD [PeriodEnd] datetime2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL DEFAULT '9999-12-31T23:59:59.9999999';

ALTER TABLE [Persons] ADD [PeriodStart] datetime2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL DEFAULT '0001-01-01T00:00:00.0000000';

ALTER TABLE [Persons] ADD PERIOD FOR SYSTEM_TIME ([PeriodStart], [PeriodEnd])

ALTER TABLE [Persons] ALTER COLUMN [PeriodStart] ADD HIDDEN

ALTER TABLE [Persons] ALTER COLUMN [PeriodEnd] ADD HIDDEN

DECLARE @historyTableSchema sysname = SCHEMA_NAME()
EXEC(N'ALTER TABLE [Persons] SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [' + @historyTableSchema + '].[PersonsHistory]))')


INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241204150321_make_temporal', N'9.0.0');

COMMIT;
GO

