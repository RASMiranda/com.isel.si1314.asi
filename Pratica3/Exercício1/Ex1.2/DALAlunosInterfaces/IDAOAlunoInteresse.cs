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
using Ex3.Entidades;
using Ex3.DALAbstraction;



namespace Ex3.AlunosInterfaces
{
    public interface IDAOAlunoInteresse : IDAO<AlunoInteresse, AlunoInteresseKey>
    {

    }
}

