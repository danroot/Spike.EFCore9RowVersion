using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
namespace Spike.EFCore9RowVersion;

public class Contact
{
    public int Id { get; set; }
    [MaxLength(100)]
    public string Name { get; set; } = "";
    [MaxLength(100)]
    public string Email { get; set; } = "";
    [MaxLength(20)]
    public string Phone { get; set; } = "";
}

public class Person
{
    public int Id { get; set; }
    [MaxLength(100)]
    public string FirstName { get; set; } = "";
    [MaxLength(100)]
    public string LastName { get; set; } = "";
    public IList<Contact> Contacts { get; set; } = [];

    public byte[] RowVersion { get; set; }  
}

public class TestDbContext : DbContext
{
    public DbSet<Contact> Contacts { get; set; }
    public DbSet<Person> Persons { get; set; }
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer("Server=.;Database=TestDb;Trusted_Connection=True;TrustServerCertificate=True;");
    }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Person>().Property(p => p.RowVersion).IsRowVersion();
    }
}

[TestClass]
public sealed class Test1
{
    [TestMethod]
    public void Should_Migrate_Database()
    {
        using var context = new TestDbContext();
        context.Database.EnsureDeleted();
        context.Database.Migrate();
        
        context.Persons.Add(new Person { FirstName = "John", LastName = "Doe", Contacts = [new Contact { Name = "Jane Doe", Email = "jane@doe.com" }] });
        context.SaveChanges();
    }
}