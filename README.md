# ExCloudflare
[![LinkedIn][linkedin-shield]][linkedin-url]

# About the project

![Cloudflare][logo-cloudflare]

Project was developed to facilitate DNS management in cloudflare through the API provided.

The Cloudflare API exposes the entire Cloudflare infrastructure through a standardized programmatic interface. Using the Cloudflare API, you can do just about anything on cloudflare.com via the client dashboard.

Requirements:

* Cloudflare Token [Generate token](https://dash.cloudflare.com/profile/api-tokens)


## Built with
 [![Elixir][Elixir-lang.org]][Elixir-url]

#
1. List all Zones
```
ExCloudflare.list_all_zone()
```

2. Lists all DNS registered in the Zone
```
ExCloudflare.get_dnsrecord("mydomain.com")
```

3. Create a new DNS in the Zone
```
ExCloudflare.create_dns_zone("subdomain6.mydomain.com", "CNAME", "google.com", 60, "mydomain.com")
```

4. Update an existing zone
```
ExCloudflare.update_dns_zone(
     %{name: "subdomain1.mydomain.com", 
          type: "A", 
          content: "127.0.0.1"
     }, 
     "mydomain.com", 
     %{content: "8.8.8.8", 
          type: "A", 
          name: "subdomain1", 
          ttl: 60
     }
)
```

5. Delete an existing zone
```
ExCloudflare.delete_dns_zone(
     %{name: "subdomain5.mydomain.com", 
          type: "A", 
          content: "127.0.0.1"
     }, "mydomain.com"
)
```

## Using Docker

#
[Image Information](https://hub.docker.com/r/dockergpsj/ex_cloudflare)

#

1. Download the Image
```
docker pull dockergpsj/ex_cloudflare:latest
```
2. Start queries on Cloudflare.

```
docker run -e "API_KEY_CLOUDFLARE=API_TOKEN" -e "FUNCTION=ExCloudflare.get_dnsrecord(\"mydomain.com\")" dockergpsj/ex_cloudflare:latest
```
Notice that there is a variable named FUNCTION.
In this field you put the name of the function you want.

[Elixir-url]: https://elixir-lang.org/
[Elixir-lang.org]: https://elixir-lang.org/images/logo/logo.png
[logo-cloudflare]: images/logo-cloudflare.png
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/gilbertosj