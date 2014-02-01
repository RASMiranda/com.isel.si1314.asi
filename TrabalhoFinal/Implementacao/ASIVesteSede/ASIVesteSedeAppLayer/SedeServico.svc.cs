using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;


namespace ASIVesteSedeAppLayer
{
    [ServiceBehavior(Namespace = "http://asiveste/services/sede")]
    public class SedeServico : ISedeServico
    {

        public List<Venda> obtemVendas()
        {
            //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
            return null;
        }

        public bool expedirEncomendaVenda(Int32 codigoVenda)
        {
            //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
            return false;
        }

        public Int32 inserirProduto(Produto produto)
        {
            if (produto == null)
            {
                throw new ArgumentNullException("produto");
            }
            //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
            return 0;
        }

        public List<Produto> obtemProdutos()
        {
            //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
            return null;
        }

        public bool inserirFornecedores(Fornecedor fornecedor)
        {
            if (fornecedor == null)
            {
                throw new ArgumentNullException("fornecedor");
            }
            //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
            return false;
        }

        public List<Fornecedor> obtemFornecedores()
        {
            //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
            return null;
        }

        public List<Encomenda> obtemEncomendasFornecedor()
        {
            //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
            return null;
        }

        public bool recebeEncomendaFornecedor(Int32 IdEncomenda)
        {
            //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
            return false;
        }
    }
}
