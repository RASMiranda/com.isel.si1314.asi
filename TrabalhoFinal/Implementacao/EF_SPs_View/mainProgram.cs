using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    /*
     * Entity Framework > Get Started > Database First 
     * http://msdn.microsoft.com/en-us/data/jj206878.aspx
     * 
     * Stored Procedures in the Entity Framework
     * http://msdn.microsoft.com/en-us/data/gg699321.aspx
     */
    class mainProgram
    {
        static void Main(string[] args)
        {
            int Id_da_Fralda;

            using (var db = new ASIVesteEntities() )
            {
                const int Id_do_Fornecedor = 2;

                // le a view vw_vProduto
                DisplayAllProdutosInDatabase(db);

                #region invocar SP inserirProduto 

                var fralda = new vProduto{Designacao = "Xixidot@EF",    FornecedorId = Id_do_Fornecedor, 
                                          Preco = 12.01m,               StockMinimo = 5,
                                          StockQtd = 7,                 Tipo = 0,  };

                Fornecedor fornecedor = (from f in db.Fornecedores
                                          where f.Id == Id_do_Fornecedor
                                          select f).First();

                fralda.Fornecedor = fornecedor;
                
                db.vProdutos.Add(fralda);

                // invoca inserirProduto
                db.SaveChanges();

                // le a view vw_vProduto
                DisplayAllProdutosInDatabase(db);

                #endregion 

                Id_da_Fralda = fralda.Id;

                #region invocar SP alterarProduto 

                vProduto fraldaDodot = (from p in db.vProdutos
                                        where p.Id == Id_da_Fralda
                                        select p).First();

                fraldaDodot.Designacao = "Dodot#EF";
                //fraldaDodot.FornecedorId
                fraldaDodot.Preco *= 2;
                fraldaDodot.StockMinimo *= 10;
                fraldaDodot.StockQtd *= 10;
                fraldaDodot.Tipo = 3; // muda de tabela ProdutoCS > ProdutoHD!! :O

                // chama alterarProduto
                db.SaveChanges();

                // le a view vw_vProduto
                DisplayAllProdutosInDatabase(db);

                #endregion 

                int debugMe = 1;

                #region invocar SP removerProduto

                db.vProdutos.Remove(fraldaDodot);

                // chama removerProduto
                db.SaveChanges();

                // le a view vw_vProduto
                DisplayAllProdutosInDatabase(db);

                #endregion

                Console.WriteLine("Press any key to exit...");
                Console.ReadKey();
            } 
        }

        private static void DisplayAllProdutosInDatabase(ASIVesteEntities db)
        {
            var produtos = from p in db.vProdutos
                            orderby p.Designacao
                            select p;

            Console.WriteLine("All Produtos in the database:");

            foreach (var produto in produtos)
            {
                Console.WriteLine("Id:{0}\t Tp:{1}\t Des:{2}\t Prc:{3}\t StQ:{4}\t StM:{5}\t Fid:{6}\t F.id:{7}",
                                  produto.Id, produto.Tipo, produto.Designacao,
                                  produto.Preco, produto.StockQtd, produto.StockMinimo,
                                  produto.FornecedorId, produto.Fornecedor.Id);
            }
        }

    }
}
