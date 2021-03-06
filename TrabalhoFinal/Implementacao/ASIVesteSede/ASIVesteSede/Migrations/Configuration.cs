namespace ASIVesteSede.Migrations
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using System.Collections.Generic;
    using ASIVesteSede.Models;

    internal sealed class Configuration : DbMigrationsConfiguration<ASIVesteSede.DAL.ASIVesteContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = true; //depois colocar a false
            AutomaticMigrationDataLossAllowed = true;
        }
        
        protected override void Seed(ASIVesteSede.DAL.ASIVesteContext context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
            //  to avoid creating duplicate seed data. E.g.
            //
            //    context.People.AddOrUpdate(
            //      p => p.FullName,
            //      new Person { FullName = "Andrew Peters" },
            //      new Person { FullName = "Brice Lambson" },
            //      new Person { FullName = "Rowan Miller" }
            //    );
            //
            var fornecedores = new List<Fornecedor>
                {
                    new Fornecedor { Numero=1,Nome="Confe��es Elite do Vouga, SA.", Morada="Estrada da Industria, Sever do Vouga"},
                    new Fornecedor { Numero=2,Nome="Desporto Rei, Lda.", Morada="Mem Martins, Sintra"}

                };
            fornecedores.ForEach(s => context.Fornecedores.AddOrUpdate(p => p.Numero, s));
            context.SaveChanges();

            var produtos = new List<Produto>
                {
                    new Produto  { Codigo="SC001", Tipo=TipoProduto.Senhora, Fornecedor=fornecedores.Single(s => s.Numero == 1), 
                        Designacao="Camisa Elite XS", StockMinimo=5,StockQtd=10, Preco= 45.9F },
                    new Produto  { Codigo="SC002", Tipo=TipoProduto.Senhora,  Fornecedor=fornecedores.Single(s => s.Numero == 1), 
                         Designacao="Camisa Elite M", StockMinimo=3,StockQtd=3, Preco= 45.9F },
                    new Produto  { Codigo="SC003", Tipo=TipoProduto.Senhora,  Fornecedor=fornecedores.Single(s => s.Numero == 1), 
                        Designacao="Camisa Elite L",  StockMinimo=2,StockQtd=5, Preco= 45.9F }
                };
            produtos.ForEach(s => context.Produtos.AddOrUpdate(p => p.Codigo, s));

            context.SaveChanges();

            var vendas = new List<Venda>
            {
                new Venda { Estado = EstadoVenda.Pendente, MoradaCliente="Rua da Alegria,23, Porto", NomeCliente="Ramalho Ortig�o", 
                    Produtos = new List< VendaProdutos> {
                        new VendaProdutos { Codigo="SC001", Qtd=2, Estado= EstadoVenda.Pendente, 
                                            Produto= produtos.Single( s => s.Codigo == "SC001")  },
                        new VendaProdutos { Codigo="SC002", Qtd = 1, Estado = EstadoVenda.Pendente, 
                                            Produto= produtos.Single( s => s.Codigo == "SC002")}
                    }
                },
                new Venda { Estado = EstadoVenda.Expedida, MoradaCliente="Rua da Alegria,23, Porto", NomeCliente="Jo�o Expedido", 
                    Produtos = new List< VendaProdutos> {
                        new VendaProdutos { Codigo="SC001", Qtd=1, Estado= EstadoVenda.Expedida, 
                                            Produto= produtos.Single( s => s.Codigo == "SC001")},
                        new VendaProdutos { Codigo="SC002", Qtd = 1, Estado = EstadoVenda.Expedida, 
                                            Produto= produtos.Single( s => s.Codigo == "SC002")}
                    }
                }
            };
            vendas.ForEach(s => context.Vendas.Add(s));

            context.SaveChanges();

            var encomendas = new List<Encomenda>
            {
                new Encomenda { Estado = EstadoEncomenda.Pendente, Qtd=5, Produto= produtos.Single( s => s.Codigo == "SC001") },
                new Encomenda { Estado = EstadoEncomenda.Pendente, Qtd=2, Produto= produtos.Single( s => s.Codigo == "SC002") },
                new Encomenda { Estado = EstadoEncomenda.Recebida, Qtd=5, Produto= produtos.Single( s => s.Codigo == "SC001") },
                new Encomenda { Estado = EstadoEncomenda.Recebida, Qtd=1, Produto= produtos.Single( s => s.Codigo == "SC002") }
             };
            encomendas.ForEach(s => context.Encomendas.Add(s));

            context.SaveChanges();
        }
    }
}
