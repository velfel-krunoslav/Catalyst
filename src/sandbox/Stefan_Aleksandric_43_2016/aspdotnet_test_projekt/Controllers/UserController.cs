using aspdotnet_test_projekt.Models;
using aspdotnet_test_projekt.Moduls;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace aspdotnet_test_projekt.Controllers
{

    [ApiController]
    [Route("[controller]")]


    public class UserController : Controller
    {
        private bazaContext bazaContext;

        public UserController(bazaContext bazaContext)
        {
            this.bazaContext = bazaContext;
        }

        [HttpGet]
        public IActionResult GetUser()
        {
            User user = this.bazaContext.users.FirstOrDefault();
            return Ok(user);
        }

        [HttpGet("Login")]
        public IActionResult Login([FromQuery] User user)
        {
            User findUser = this.bazaContext.users.Where(x => x.Username == user.Username && x.Password == user.Password).FirstOrDefault();
            if(findUser != null)
            {
                return Ok(true);
            }
            return Ok(false);
        }
        
    }
}
