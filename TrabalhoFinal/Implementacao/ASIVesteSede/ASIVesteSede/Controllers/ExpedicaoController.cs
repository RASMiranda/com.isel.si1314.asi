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
    public class ExpedicaoController : Controller
    {
        private ASIVesteContext db = new ASIVesteContext();

        //
        // GET: /Expedicao/

        public ActionResult Index()
        {
            //return View(db.Vendas.Include(s =>s.Produtos ).Where( s=> s.Estado == EstadoVenda.Pendente).ToList());
            return View(db.Vendas.Where(s => s.Estado == EstadoVenda.Pendente).ToList());
        }

        //
        // GET: /Expedicao/Details/5

        public ActionResult Expedicao(int id = 0)
        {
            Venda venda = db.Vendas.Find(id);

            if (venda == null)
            {
                return HttpNotFound();
            }
            else
            {
                venda.Estado = EstadoVenda.Expedida;
                db.Entry(venda).State = EntityState.Modified;
                db.SaveChanges();

            }
            return RedirectToAction("Index");
        }

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
        // GET: /Expedicao/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Expedicao/Create

        [HttpPost]
        public ActionResult Create(Venda venda)
        {
            if (ModelState.IsValid)
            {
                db.Vendas.Add(venda);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(venda);
        }

        //
        // GET: /Expedicao/Edit/5

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
        // POST: /Expedicao/Edit/5

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
        // GET: /Expedicao/Delete/5

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
        // POST: /Expedicao/Delete/5

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