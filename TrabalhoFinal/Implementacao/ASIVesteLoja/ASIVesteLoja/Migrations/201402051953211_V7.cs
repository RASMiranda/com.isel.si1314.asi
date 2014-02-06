namespace ASIVesteLoja.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class V7 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Produto", "RowVersion", c => c.Binary(nullable: false, fixedLength: true, timestamp: true, storeType: "rowversion"));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Produto", "RowVersion");
        }
    }
}
