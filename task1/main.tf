# 1. Віртуальна приватна хмара (VPC)
resource "digitalocean_vpc" "main_vpc" {
  name     = "andrus-vpc"
  region   = "fra1"
  # Змінено діапазон, щоб уникнути конфлікту
  ip_range = "10.10.11.0/24" 
}

# 2. Налаштування фаєрволу
resource "digitalocean_firewall" "main_firewall" {
  name = "andrus-firewall" # Назва: <Ваше прізвище>-firewall [cite: 11]

  droplet_ids = [digitalocean_droplet.k8s_node.id]

  # Вхідні (inbound) підключення портів: 22; 80; 443; 8000; 8001; 8002; 8003 [cite: 12]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8000-8003"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Вихідні (outbound): підключення портів: 1-65535 [cite: 13]
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# 3. ВМ (Droplet)
resource "digitalocean_droplet" "k8s_node" {
  name   = "andrus-node" # Назва: <Ваше прізвище>-node [cite: 14]
  # Розмір: повинен відповідати системним вимогам для запуску Minikube, Kubernetes (мінімум 2 CPU, 2 GB RAM) [cite: 15]
  size   = "s-2vcpu-4gb" 
  image  = "ubuntu-24-04-x64" # Образ ОС: Ubuntu 24 
  region = "fra1" # Регіон: ідентичний до VPC [cite: 17]
  vpc_uuid = digitalocean_vpc.main_vpc.id
  
  # Опціонально: додай свій SSH ключ, щоб мати доступ до ноди
  # ssh_keys = [ data.digitalocean_ssh_key.my_key.id ]
}

# 4. Сховище для об'єктів (бакет)
resource "digitalocean_spaces_bucket" "main_bucket" {
  name   = "andrus-bucket" # Назва: <Ваше прізвище>-bucket [cite: 19]
  region = "fra1" # Регіон: ідентичний до VPC [cite: 21]
  # Тип сховища за замовчуванням (базовий бакет без CDN чи особливих ACL) [cite: 20]
}
