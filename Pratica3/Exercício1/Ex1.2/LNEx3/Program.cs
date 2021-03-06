﻿/*
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
using Ex3.SpecificDAL;

using System.Transactions; 

using System.Collections;


using Ex3.Entidades;
using Ex3.AlunosInterfaces;
using System.Data.SqlClient;




namespace LNEx2
{
    class Program
    {
        static void Main(string[] args)
        {
            Aluno a = new Aluno();
            a.Numero = 1111;
            a.Nome = "zeca";

            a.Interesses = new List<AlunoInteresse>();

            var ai = new AlunoInteresse();
            ai.Numero = a.Numero;
            ai.Interesse = "i1";

            a.Interesses.Add(ai);

            ai = new AlunoInteresse();
            ai.Numero = a.Numero;
            ai.Interesse = "i2";
            a.Interesses.Add(ai);

            Aluno a1 = new Aluno();
            a1.Numero = 2222;
            a1.Nome = "rita";

            a1.Interesses = new List<AlunoInteresse>();
            ai = new AlunoInteresse();
            ai.Numero = a1.Numero;
            ai.Interesse = "i2";
            a1.Interesses.Add(ai);

            ai = new AlunoInteresse();
            ai.Numero = a1.Numero;
            ai.Interesse = "i3";
            a1.Interesses.Add(ai);
           

            using (var ts = new TransactionScope())
            {
                IDAOAluno dao = new DAOAluno();
                try
                {
                    dao.Create(a);
                    dao.Create(a1);
                }
                catch (SqlException ex)
                {
                    Console.Error.WriteLine(ex.GetType().Name+":"+ex.Message);
                    Environment.Exit(-1);
                }
                ts.Complete();
            }

         
           
           
        }
    }
}
