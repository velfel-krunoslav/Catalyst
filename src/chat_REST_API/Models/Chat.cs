using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace chat_SignalR.Models
{
    public class Chat
    {
        
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Id_Sender { get; set; }

        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Id_Reciever { get; set; }
    }
}
