using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;
using ASIVesteSede.Models;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using System.Data.Objects;
using System.Data.Entity.Infrastructure;
using ASIVesteSede.Models;
using System.Data.SqlClient;
using System.Data;

namespace ASIVesteSede.DAL
{
    public class ASIVesteContext : DbContext
    {
        public DbSet<Fornecedor> Fornecedores { get; set; }
        public DbSet<Produto> Produtos { get; set; }
        public DbSet<Venda> Vendas { get; set; }
        public DbSet<VendaProdutos> VendasProdutos { get; set; }
        public DbSet<Encomenda> Encomendas { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }


        public virtual int sp_realizarEncomenda(string codigoProduto, Nullable<int> qtdEncomendada, Nullable<int> vendaId)
        {
            var codigoProdutoParameter = codigoProduto != null ?
                new ObjectParameter("CodigoProduto", codigoProduto) :
                new ObjectParameter("CodigoProduto", typeof(string));

            var qtdEncomendadaParameter = qtdEncomendada.HasValue ?
                new ObjectParameter("QtdEncomendada", qtdEncomendada) :
                new ObjectParameter("QtdEncomendada", typeof(int));

            var vendaIdParameter = vendaId.HasValue ?
                new ObjectParameter("VendaId", vendaId) :
                new ObjectParameter("VendaId", typeof(int));

            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_realizarEncomenda", codigoProdutoParameter, qtdEncomendadaParameter, vendaIdParameter);
        }

        public virtual int sp_realizarVenda(string nomeCliente, string moradaCliente, string codigoProduto, Nullable<int> qtd)
        {
            var nomeClienteParameter = nomeCliente != null ?
                new ObjectParameter("NomeCliente", nomeCliente) :
                new ObjectParameter("NomeCliente", typeof(string));

            var moradaClienteParameter = moradaCliente != null ?
                new ObjectParameter("MoradaCliente", moradaCliente) :
                new ObjectParameter("MoradaCliente", typeof(string));

            var codigoProdutoParameter = codigoProduto != null ?
                new ObjectParameter("CodigoProduto", codigoProduto) :
                new ObjectParameter("CodigoProduto", typeof(string));

            var qtdParameter = qtd.HasValue ?
                new ObjectParameter("Qtd", qtd) :
                new ObjectParameter("Qtd", typeof(int));

            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_realizarVenda", nomeClienteParameter, moradaClienteParameter, codigoProdutoParameter, qtdParameter);
        }

        public virtual int sp_receberEncomenda(Nullable<int> encomendaId)
        {
            var encomendaIdParameter = new SqlParameter("Id", SqlDbType.Int);
            encomendaIdParameter.Value = encomendaId;

            return ((IObjectContextAdapter)this).ObjectContext.ExecuteStoreCommand("sp_receberEncomenda @EncomendaId=@Id", encomendaIdParameter);
        }

        //public virtual int sp_receberEncomenda(Nullable<int> encomendaId)
        //{
        //    var encomendaIdParameter = encomendaId.HasValue ?
        //        new ObjectParameter("EncomendaId", encomendaId) :
        //        new ObjectParameter("EncomendaId", typeof(int));
        //"The FunctionImport 'sp_receberEncomenda' could not be found in the container 'ASIVesteContext'."
        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_receberEncomenda", encomendaIdParameter);
        //}

        public virtual int sp_actualizarProduto(Nullable<int> produtoId, Nullable<int> tipo, string codigo, string designacao, Nullable<int> stockQtd, Nullable<int> stockMinimo, Nullable<float> preco, Nullable<int> fornecedorId, string novoCodigo)
        {
            var produtoIdParameter = produtoId.HasValue ?
                new ObjectParameter("ProdutoId", produtoId) :
                new ObjectParameter("ProdutoId", typeof(int));

            var tipoParameter = tipo.HasValue ?
                new ObjectParameter("Tipo", tipo) :
                new ObjectParameter("Tipo", typeof(int));

            var codigoParameter = codigo != null ?
                new ObjectParameter("Codigo", codigo) :
                new ObjectParameter("Codigo", typeof(string));

            var designacaoParameter = designacao != null ?
                new ObjectParameter("Designacao", designacao) :
                new ObjectParameter("Designacao", typeof(string));

            var stockQtdParameter = stockQtd.HasValue ?
                new ObjectParameter("StockQtd", stockQtd) :
                new ObjectParameter("StockQtd", typeof(int));

            var stockMinimoParameter = stockMinimo.HasValue ?
                new ObjectParameter("StockMinimo", stockMinimo) :
                new ObjectParameter("StockMinimo", typeof(int));

            var precoParameter = preco.HasValue ?
                new ObjectParameter("Preco", preco) :
                new ObjectParameter("Preco", typeof(float));

            var fornecedorIdParameter = fornecedorId.HasValue ?
                new ObjectParameter("FornecedorId", fornecedorId) :
                new ObjectParameter("FornecedorId", typeof(int));

            var novoCodigoParameter = novoCodigo != null ?
                new ObjectParameter("novoCodigo", novoCodigo) :
                new ObjectParameter("novoCodigo", typeof(string));

            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_actualizarProduto", produtoIdParameter, tipoParameter, codigoParameter, designacaoParameter, stockQtdParameter, stockMinimoParameter, precoParameter, fornecedorIdParameter, novoCodigoParameter);
        }

        public virtual int sp_inserirProduto(Nullable<int> tipo, string codigo, string designacao, Nullable<int> stockQtd, Nullable<int> stockMinimo, Nullable<float> preco, Nullable<int> fornecedorId)
        {
            var tipoParameter = tipo.HasValue ?
                new ObjectParameter("Tipo", tipo) :
                new ObjectParameter("Tipo", typeof(int));

            var codigoParameter = codigo != null ?
                new ObjectParameter("Codigo", codigo) :
                new ObjectParameter("Codigo", typeof(string));

            var designacaoParameter = designacao != null ?
                new ObjectParameter("Designacao", designacao) :
                new ObjectParameter("Designacao", typeof(string));

            var stockQtdParameter = stockQtd.HasValue ?
                new ObjectParameter("StockQtd", stockQtd) :
                new ObjectParameter("StockQtd", typeof(int));

            var stockMinimoParameter = stockMinimo.HasValue ?
                new ObjectParameter("StockMinimo", stockMinimo) :
                new ObjectParameter("StockMinimo", typeof(int));

            var precoParameter = preco.HasValue ?
                new ObjectParameter("Preco", preco) :
                new ObjectParameter("Preco", typeof(float));

            var fornecedorIdParameter = fornecedorId.HasValue ?
                new ObjectParameter("FornecedorId", fornecedorId) :
                new ObjectParameter("FornecedorId", typeof(int));

            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_inserirProduto", tipoParameter, codigoParameter, designacaoParameter, stockQtdParameter, stockMinimoParameter, precoParameter, fornecedorIdParameter);
        }

        public virtual int sp_removerProduto(Nullable<int> produtoId, string codigo)
        {
            var produtoIdParameter = produtoId.HasValue ?
                new ObjectParameter("ProdutoId", produtoId) :
                new ObjectParameter("ProdutoId", typeof(int));

            var codigoParameter = codigo != null ?
                new ObjectParameter("Codigo", codigo) :
                new ObjectParameter("Codigo", typeof(string));

            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_removerProduto", produtoIdParameter, codigoParameter);
        }

        public DbSet<Reclamacao> Reclamacaos { get; set; }

    }
    
}