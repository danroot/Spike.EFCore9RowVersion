This repo demonstrates a regression with EF Core 9 migrations as relates to temporal tables and rowversions.  If the migration was created under EF Core 8 and contains a temporal table against a table with rowversion enabled, but then migration is run under EF Core 9, then the migration fails with the error
"Cannot alter column 'RowVersion' to be data type timestamp.". 
For convenience, migration.sql illustrates the sql that gets generated in this scenario.  In this repository, the migrations were generated under EF Core 8, then the Nuget packages updated to EF Core 9.

Steps to reproduce with this repo:
- be sure the connection string is correct in OnConfiguring.  Note the database will be dropped in the test.
- run the test
- observe test fails with "Cannot alter column 'RowVersion' to be data type timestamp"
- Change Microsoft.EntityFrameworkCore.* packages to 8.0.11
- run test
- observe no errors

Steps to reproduce from scratch:
- Create a EF Core 8 db context (ie Microsoft.EntityFrameworkCore.* packages are v 8.0.11)
- Add an initial migration: dotnet ef migrations add initialmigration
- Update the table to have a rowversion property: public byte[] RowVersion{get;set;}
- Update OnModelCreating to use rowversion: modelBuilder.Entity<Person>(entity => { entity.Property(e => e.RowVersion).IsRowVersion(); });
- Add a migration for this change: dotnet ef migrations add add_rowversion
- Update the tables to use temporal tables in OnModelCreating of the db context:  modelBuilder.Entity<Person>(entity => { entity.ToTable("Persons", t=>t.IsTemporal()); entity.Property(e => e.RowVersion).IsRowVersion(); });
- Add a migration for the db context change: dotnet ef migrations add make_temporal
- Observe you can create the database:  context.Database.EnsureDeleted(); context.Database.Migrate();
- Update the Microsoft.EntityFrameworkCore.* nuget packages to to EF Core 9 
- Run the migration by calling context.Database.Migrate or using dotnet ef database update
- Observe error "Cannot alter column 'RowVersion' to be data type timestamp."
