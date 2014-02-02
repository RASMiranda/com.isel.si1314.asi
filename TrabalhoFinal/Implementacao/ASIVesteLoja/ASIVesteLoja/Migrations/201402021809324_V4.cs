namespace ASIVesteLoja.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class V4 : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.VendaItem", "Venda_VendaID", "dbo.Venda");
            DropIndex("dbo.VendaItem", new[] { "Venda_VendaID" });
            DropTable("dbo.VendaItem");
        }
        
        public override void Down()
        {
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
                .PrimaryKey(t => t.VendaItemID);
            
            CreateIndex("dbo.VendaItem", "Venda_VendaID");
            AddForeignKey("dbo.VendaItem", "Venda_VendaID", "dbo.Venda", "VendaID");
        }
    }
}
