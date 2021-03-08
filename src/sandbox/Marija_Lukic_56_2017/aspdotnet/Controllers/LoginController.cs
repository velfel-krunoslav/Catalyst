using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication2.Controllers
{
    [Route("[controller]")]
    public class LoginController : Controller
    {
        [HttpGet]
        public IActionResult Index()
        {
            return Ok("LOGIN");
        }

        [HttpPost]
        public IActionResult login([FromBody] User u)
        {
            if (u.username == "Maja" && u.password == "Maja")
                return Ok();
            return Unauthorized();
        }

    }

    public class User
    {
        public string username { get; set; }
        public string password { get; set; }
        public string blabla { get; set; }
    }
}
