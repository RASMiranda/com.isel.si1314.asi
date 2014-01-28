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
    public class FornecedorController : Controller
    {
        private ASIVesteContext db = new ASIVesteContext();

        //
        // GET: /Fornecedor/

        public ActionResult Index()
        {
            return View(db.Fornecedores.ToList());
        }

        //
        // GET: /Fornecedor/Details/5

        public ActionResult Details(int id = 0)
        {
            Fornecedor fornecedor = db.Fornecedores.Find(id);
            if (fornecedor == null)
            {
                return HttpNotFound();
            }
            return View(fornecedor);
        }

        //
        // GET: /Fornecedor/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Fornecedor/Create

        [HttpPost]
        public ActionResult Create(Fornecedor fornecedor)
        {
            if (ModelState.IsValid)
            {
                db.Fornecedores.Add(fornecedor);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(fornecedor);
        }

        //
        // GET: /Fornecedor/Edit/5

        public ActionResult Edit(int id = 0)
        {
            Fornecedor fornecedor = db.Fornecedores.Find(id);
            if (fornecedor == null)
            {
                return HttpNotFound();
            }
            return View(fornecedor);
        }

        //
        // POST: /Fornecedor/Edit/5

        [HttpPost]
        public ActionResult Edit(Fornecedor fornecedor)
        {
            if (ModelState.IsValid)
            {
                db.Entry(fornecedor).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(fornecedor);
        }

        //
        // GET: /Fornecedor/Delete/5

        public ActionResult Delete(int id = 0)
        {
            Fornecedor fornecedor = db.Fornecedores.Find(id);
            if (fornecedor == null)
            {
                return HttpNotFound();
            }
            return View(fornecedor);
        }

        //
        // POST: /Fornecedor/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Fornecedor fornecedor = db.Fornecedores.Find(id);
            db.Fornecedores.Remove(fornecedor);
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