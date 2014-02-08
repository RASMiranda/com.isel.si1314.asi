namespace ASIVesteLoja.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class V8_Reclamacao : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Reclamacao",
                c => new
                    {
                        ReclamacaoID = c.Int(nullable: false, identity: true),
                        ClienteBI = c.String(),
                        Texto = c.String(),
                        DataInsercao = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.ReclamacaoID);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Reclamacao");
        }
    }
}
