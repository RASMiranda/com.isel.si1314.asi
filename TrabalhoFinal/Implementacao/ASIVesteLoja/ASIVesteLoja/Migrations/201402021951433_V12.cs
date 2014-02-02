namespace ASIVesteLoja.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class V12 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Venda", "codigoProduto", c => c.String());
            AddColumn("dbo.Venda", "quantidade", c => c.Int(nullable: false));
            DropColumn("dbo.Venda", "numItems");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Venda", "numItems", c => c.Int(nullable: false));
            DropColumn("dbo.Venda", "quantidade");
            DropColumn("dbo.Venda", "codigoProduto");
        }
    }
}
