using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace EP2021.Models
{
    public class Product
    {
        public int ProductID { get; set; }
        [StringLength(50)]
        public string Name { get; set; }
        [StringLength(200)]
        public string ShortDescription { get; set; }
        public string LongDescription { get; set; }
        [Range(0, double.MaxValue)]
        public decimal Price { get; set; }
        [StringLength(200)]
        public string ImageUrl { get; set; }
        public bool IsPrefered { get; set; }
        [Range(0, int.MaxValue)]
        public int InStock { get; set; }
        [Range(0, int.MaxValue)]
        public int NumberOfOrders { get; set; }
        [DataType(DataType.DateTime)]
        public DateTime DateCreate { get; set; }

        //foreign key
        public int CategoryID { get; set; }
        public Category Category { get; set; }
    }
}
