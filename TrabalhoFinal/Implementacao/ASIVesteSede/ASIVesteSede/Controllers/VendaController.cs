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
            return View(db.Vendas.ToList());
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
            if (ModelState.IsValid)
            {
                db.Vendas.Add(venda);
                db.SaveChanges();
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