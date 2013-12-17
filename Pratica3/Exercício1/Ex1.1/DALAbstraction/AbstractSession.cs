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


using System.Data;
using System.Data.SqlClient;

using System.Configuration;


namespace Ex2.DALAbstraction
{
    public abstract class AbstractSession : ISession
    {
 
        private SqlTransaction  currentTrans = null;
        private SqlConnection currentConn = null;
        private string cs;
        private bool TransactionVotes;

        public AbstractSession()
        {
            cs = ConfigurationManager.ConnectionStrings["base dados"].ConnectionString;
        }

        public DataAccessScope CreateDataAccessScope(bool requiresTrans)
        {
            bool sc, st;
            if (currentConn == null)
            {
                currentConn = new SqlConnection(cs);
                currentConn.Open();
                sc = true;
            }
            else sc = false;
            if (requiresTrans && currentTrans == null)
            {
                currentTrans = currentConn.BeginTransaction();
                TransactionVotes = true;
                st = true;
            }
            else
                st = false;
            return new DataAccessScope(this, st, sc);
        }
         
        public void EndTransaction(bool MyVote, bool isMyTransaction) {
             TransactionVotes &= MyVote;
             if (isMyTransaction) {
                 if (TransactionVotes)
                     currentTrans.Commit();
                 else
                     currentTrans.Rollback();
                 currentTrans = null;
             }

         }

         public void CloseConnection(bool isMyConnection)
         {
             if (isMyConnection && currentConn != null)
             {
                 currentConn.Close();
                 currentConn = null;
             }
         }

         public SqlCommand CreateCommand()
         {
             SqlCommand cmd = currentConn.CreateCommand();

             cmd.Transaction = currentTrans;

             return cmd;
         }

         public void Dispose()
         {
             if (currentConn != null)
                 currentConn.Dispose();
         }


    }
}
