using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ex2.Entidades
{
    

    public class AlunoInteresseKey
    {
        private int _numAl, _nSeq;

       public AlunoInteresseKey (int numAl , int nSeq )
       {
        this._numAl = numAl;
        this._nSeq = nSeq;

       }
       public int NumAl {get{return _numAl;}}
       public int NSeq { get{return _nSeq;} }
    }
}
