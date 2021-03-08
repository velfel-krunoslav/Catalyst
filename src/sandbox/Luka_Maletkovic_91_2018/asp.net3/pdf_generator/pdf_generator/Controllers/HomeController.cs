using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using pdf_generator.Models;
using pdf_generator.Reports;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace pdf_generator.Controllers
{
    public class HomeController : Controller
    {
        private readonly IWebHostEnvironment _oHostEnvironment;

        public HomeController(IWebHostEnvironment oHostEnvironment)
        {
            _oHostEnvironment = oHostEnvironment;
        }

        public IActionResult Index()
        {
            return View();
        }

        public ActionResult PrintOsoba(int param)
        {
            List<Osoba> oOsobe = new List<Osoba>();

            for (int i = 0; i < 10; i++)
            {
                Osoba oOsoba = new Osoba();
                oOsoba.id = i;
                oOsoba.Name = "Osoba" + i;
                oOsoba.Address = "Adresa" + i;


                oOsobe.Add(oOsoba);
            }

            OsobaReport rpt = new OsobaReport(_oHostEnvironment);
            return File(rpt.Report(oOsobe), "application/pdf");

        }
    }
}
