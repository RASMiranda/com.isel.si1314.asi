namespace ASIVesteSede.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Fornecedor",
                c => new
                    {
                        FornecedorID = c.Int(nullable: false, identity: true),
                        Numero = c.Int(nullable: false),
                        Nome = c.String(),
                        Morada = c.String(),
                    })
                .PrimaryKey(t => t.FornecedorID);
            
            CreateTable(
                "dbo.Produto",
                c => new
                    {
                        ProdutoID = c.Int(nullable: false, identity: true),
                        Tipo = c.Int(),
                        Codigo = c.String(),
                        Designacao = c.String(),
                        StockQtd = c.Int(nullable: false),
                        StockMinimo = c.Int(nullable: false),
                        Preco = c.Single(nullable: false),
                        Fornecedor_FornecedorID = c.Int(),
                        Encomenda_EncomendaID = c.Int(),
                    })
                .PrimaryKey(t => t.ProdutoID)
                .ForeignKey("dbo.Fornecedor", t => t.Fornecedor_FornecedorID)
                .ForeignKey("dbo.Encomenda", t => t.Encomenda_EncomendaID)
                .Index(t => t.Fornecedor_FornecedorID)
                .Index(t => t.Encomenda_EncomendaID);
            
            CreateTable(
                "dbo.Venda",
                c => new
                    {
                        VendaID = c.Int(nullable: false, identity: true),
                        NomeCliente = c.String(),
                        MoradaCliente = c.String(),
                        Estado = c.Int(),
                    })
                .PrimaryKey(t => t.VendaID);
            
            CreateTable(
                "dbo.VendaProdutos",
                c => new
                    {
                        VendaProdutosID = c.Int(nullable: false, identity: true),
                        NomeCliente = c.String(),
                        Qtd = c.Int(nullable: false),
                        Estado = c.Int(),
                        Venda_VendaID = c.Int(),
                        Produto_ProdutoID = c.Int(),
                    })
                .PrimaryKey(t => t.VendaProdutosID)
                .ForeignKey("dbo.Venda", t => t.Venda_VendaID)
                .ForeignKey("dbo.Produto", t => t.Produto_ProdutoID)
                .Index(t => t.Venda_VendaID)
                .Index(t => t.Produto_ProdutoID);
            
            CreateTable(
                "dbo.Encomenda",
                c => new
                    {
                        EncomendaID = c.Int(nullable: false, identity: true),
                        Qtd = c.Int(nullable: false),
                        Estado = c.Int(),
                        VendaProduto_VendaProdutosID = c.Int(),
                    })
                .PrimaryKey(t => t.EncomendaID)
                .ForeignKey("dbo.VendaProdutos", t => t.VendaProduto_VendaProdutosID)
                .Index(t => t.VendaProduto_VendaProdutosID);
            
        }
        
        public override void Down()
        {
            DropIndex("dbo.Encomenda", new[] { "VendaProduto_VendaProdutosID" });
            DropIndex("dbo.VendaProdutos", new[] { "Produto_ProdutoID" });
            DropIndex("dbo.VendaProdutos", new[] { "Venda_VendaID" });
            DropIndex("dbo.Produto", new[] { "Encomenda_EncomendaID" });
            DropIndex("dbo.Produto", new[] { "Fornecedor_FornecedorID" });
            DropForeignKey("dbo.Encomenda", "VendaProduto_VendaProdutosID", "dbo.VendaProdutos");
            DropForeignKey("dbo.VendaProdutos", "Produto_ProdutoID", "dbo.Produto");
            DropForeignKey("dbo.VendaProdutos", "Venda_VendaID", "dbo.Venda");
            DropForeignKey("dbo.Produto", "Encomenda_EncomendaID", "dbo.Encomenda");
            DropForeignKey("dbo.Produto", "Fornecedor_FornecedorID", "dbo.Fornecedor");
            DropTable("dbo.Encomenda");
            DropTable("dbo.VendaProdutos");
            DropTable("dbo.Venda");
            DropTable("dbo.Produto");
            DropTable("dbo.Fornecedor");
        }
    }
}
