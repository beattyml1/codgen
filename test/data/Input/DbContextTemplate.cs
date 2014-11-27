using {{ApplicationName}}.Models;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

namespace {{ApplicationName}}.DAL
{
    public class {{ApplicationName}}Context : DbContext
    {
        {{#entities}}
        public DbSet<Blog> {{EntityNames}} { get; set; }
        {{/entities}}

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {

        }
    }
}