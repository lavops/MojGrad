using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace probnaApp.Models
{
    public class Korisnik
    {
        public long id { get; set; }
        public string ime { get; set; }
        public string prezime { get; set; }
        public string email { get; set; }
        public string sifra { get; set; }
    
    }
}
