namespace ASIVesteLoja.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Produto",
                c => new
                    {
                        ProdutoID = c.Int(nullable: false, identity: true),
                        Codigo = c.String(),
                        Designacao = c.String(),
                        StockQtd = c.Int(nullable: false),
                        Preco = c.Single(nullable: false),
                    })
                .PrimaryKey(t => t.ProdutoID);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Produto");
        }
    }
}
