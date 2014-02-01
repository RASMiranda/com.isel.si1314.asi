using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace ASIVesteSedeAppLayer
{
    [ServiceContract(Namespace = "http://asiveste/services/sede")]
    public interface ISedeServico
    {
        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="venda"></param>
        [OperationContract]
        List<Venda> obtemVendas();

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="CodigoVenda"></param>
        /// <returns></returns>
        [OperationContract]
        bool expedirEncomendaVenda(Int32 codigoVenda);

        /// <summary>
        /// TODO
        /// </summary>
        /// <param name="produto"></param>
        /// <returns></returns>
        [OperationContract]
        Int32 inserirProduto(Produto produto);

        /// <summary>
        /// TODO
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        List<Produto> obtemProdutos();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fornecedor"></param>
        [OperationContract]
        bool inserirFornecedores(Fornecedor fornecedor);

        /// <summary>
        /// TODO
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        List<Fornecedor> obtemFornecedores();

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        List<Encomenda> obtemEncomendasFornecedor();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="IdEncomenda"></param>
        /// <returns></returns>
        [OperationContract]
        bool recebeEncomendaFornecedor(Int32 IdEncomenda);

    }
}
