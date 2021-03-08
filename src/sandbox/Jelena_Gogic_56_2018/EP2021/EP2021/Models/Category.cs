using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace EP2021.Models
{
    public class Category
    {
        public int CategoryID { get; set; }
        [StringLength(50)]
        [Column("Name")]
        public string CategoryName { get; set; }
        public string Description { get; set; }
         //foreign key
        public virtual List<Product> Products { get; set; }
    }
}
