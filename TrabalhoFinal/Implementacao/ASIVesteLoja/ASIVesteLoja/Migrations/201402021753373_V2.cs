namespace ASIVesteLoja.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class V2 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Venda",
                c => new
                    {
                        VendaID = c.Int(nullable: false, identity: true),
                        nomeCliente = c.String(),
                        moradaCliente = c.String(),
                        numItems = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.VendaID);
            
            CreateTable(
                "dbo.VendaItem",
                c => new
                    {
                        VendaItemID = c.Int(nullable: false, identity: true),
                        codigo = c.String(),
                        precoUnitario = c.Single(nullable: false),
                        quantidade = c.Int(nullable: false),
                        Venda_VendaID = c.Int(),
                    })
                .PrimaryKey(t => t.VendaItemID)
                .ForeignKey("dbo.Venda", t => t.Venda_VendaID)
                .Index(t => t.Venda_VendaID);
            
        }
        
        public override void Down()
        {
            DropIndex("dbo.VendaItem", new[] { "Venda_VendaID" });
            DropForeignKey("dbo.VendaItem", "Venda_VendaID", "dbo.Venda");
            DropTable("dbo.VendaItem");
            DropTable("dbo.Venda");
        }
    }
}
