/*
 * Este código foi desenvolvido para exemplificação e consolidação
 * de coceitos da unidade curricular Arquitectura de Sistemas de Informação do
 * Mestredo em Engenharia Informática e de Computadores do Instituto Superior de Engenharia
 * de Lisboa (Institupo Politécnico de Lisboa)
 * Não é completo, nem é destinado a ser usado como peça de produtos informáticos fora 
 * do âmbito pedagógico.
 * 
 * -------------------------------------
 * Autor: Walter Vieira
 * -------------------------------------
 * Data de criaçao: 2012/11/14
 * -------------------------------------
 * História de alterações:
 * 
 * 2012/11/19 - Walter Vieira. Introduzidos estes comentários.
 * 
 * 
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ex2.DALAbstraction
{
    // define um dominio de acesso a dados garantindo a existência de uma conexão e, possivelmente a criação de uma transacção
    public class DataAccessScope: IDisposable
    {
        private ISession MySession;
        private bool isMyTransaction = false;
        private bool isMyConnection = false;
        private bool MyVote = false;

        public DataAccessScope(ISession s, bool startTrans, bool startConnection)
        {
            MySession = s;
            isMyTransaction = startTrans;
            isMyConnection = startConnection;
        }

        public void Commit()
        {
            MyVote = true;
        }

        public void Dispose()
        {
       
            MySession.EndTransaction(MyVote, isMyTransaction);
            MySession.CloseConnection(isMyConnection);
        }

    }
}
