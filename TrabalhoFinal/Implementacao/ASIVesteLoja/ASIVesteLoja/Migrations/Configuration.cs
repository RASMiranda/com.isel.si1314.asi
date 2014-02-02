namespace ASIVesteLoja.Migrations
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using ASIVesteLoja.Models;

    internal sealed class Configuration : DbMigrationsConfiguration<ASIVesteLoja.DAL.ASIVesteContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = true; //depois colocar a false
            AutomaticMigrationDataLossAllowed = true;
        }

        protected override void Seed(ASIVesteLoja.DAL.ASIVesteContext context)
        {
            var produtos = new List<Produto>
                {
                    new Produto  { 
                        Codigo="SC001",
                        Designacao="Camisa Elite XS", 
                        StockQtd=10, 
                        Preco= 45.9F },
                    new Produto  { 
                        Codigo="SC002", 
                         Designacao="Camisa Elite M", 
                         StockQtd=3, 
                         Preco= 45.9F },
                    new Produto  { 
                        Codigo="SC003", 
                        Designacao="Camisa Elite L",  
                        StockQtd=5, 
                        Preco= 45.9F }
                };
            produtos.ForEach(s => context.Produtos.AddOrUpdate(p => p.Codigo, s));

            context.SaveChanges();
        }
    }
}
