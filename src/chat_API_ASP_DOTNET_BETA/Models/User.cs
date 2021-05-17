using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using SignalR_chat_API.Interfaces;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace chat_SignalR.Models
{
    public class User
    {
        public int Id { get; set; }

        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        [Column(TypeName = "varchar(200)")]
        public string metaMaskAddress { get; set; }

        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public string privateKey { get; set; }
        [Required]
        public string First_Name { get; set; }
        [Required]
        public string Last_Name { get; set; }
    }
}
