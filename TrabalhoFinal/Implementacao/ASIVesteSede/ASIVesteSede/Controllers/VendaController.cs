using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASIVesteSede.Models;
using ASIVesteSede.DAL;

namespace ASIVesteSede.Controllers
{
    public class VendaController : Controller
    {
        private ASIVesteContext db = new ASIVesteContext();

        //
        // GET: /Venda/

        public ActionResult Index()
        {
            
            var vendas = db.Vendas.Include(v => v.Produtos).OrderBy( v => v.VendaID);

            
            
            return View(vendas.ToList());
        }

        //
        // GET: /Venda/Details/5

        public ActionResult Details(int id = 0)
        {
            Venda venda = db.Vendas.Find(id);
            if (venda == null)
            {
                return HttpNotFound();
            }
            return View(venda);
        }

        //
        // GET: /Venda/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Venda/Create

        [HttpPost]
        public ActionResult Create(Venda venda)
        {
            if( venda.Produtos.Count < 1 || 1 < venda.Produtos.Count)
                throw new Exception("Apenas a venda de um produto é suportada.");

            if (ModelState.IsValid)
            {
                db.sp_realizarVenda(
                    venda.NomeCliente, 
                    venda.MoradaCliente, 
                    venda.Produtos.First().Codigo,
                    venda.Produtos.First().Qtd
                );

                db.Vendas.Add(venda);
                db.Entry<Venda>(venda).State = EntityState.Unchanged;
                //db.SaveChanges();

                return RedirectToAction("Index");
            }

            return View(venda);
        }

        //
        // GET: /Venda/Edit/5

        public ActionResult Edit(int id = 0)
        {
            Venda venda = db.Vendas.Find(id);
            if (venda == null)
            {
                return HttpNotFound();
            }
            return View(venda);
        }

        //
        // POST: /Venda/Edit/5

        [HttpPost]
        public ActionResult Edit(Venda venda)
        {
            if (ModelState.IsValid)
            {
                db.Entry(venda).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(venda);
        }

        //
        // GET: /Venda/Delete/5

        public ActionResult Delete(int id = 0)
        {
            Venda venda = db.Vendas.Find(id);
            if (venda == null)
            {
                return HttpNotFound();
            }
            return View(venda);
        }

        //
        // POST: /Venda/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Venda venda = db.Vendas.Find(id);
            db.Vendas.Remove(venda);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}