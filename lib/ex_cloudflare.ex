defmodule ExCloudflare do
  @moduledoc false

def list_all_zone() do
  Cloudflare.Client.init()

  case Cloudflare.Zone.index() do
    {:ok, %Tesla.Env{body: body, status: 200}} ->
    
    for dns <- body["result"] do
      %{
        name: dns["name"],
        id: dns["id"],
        name_servers: dns["name_servers"],
        status: dns["status"],
      }
    end

    {:ok, %Tesla.Env{body: body, status: 400}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {:ok, %Tesla.Env{body: body, status: 403}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {:ok, %Tesla.Env{body: body, status: 404}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {:ok, %Tesla.Env{body: body, status: 405}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {_, _} -> raise "Oops, something went wrong!"

  end

end

# ExCloudflare.get_dnsrecord("mydomain.com")
def get_dnsrecord(zone_name) do
  Cloudflare.Client.init()

  zone = list_all_zone() 
          |> Enum.filter(& &1.name == zone_name) 
          |> Enum.at(0)

  case Cloudflare.DnsRecord.index(params: [zone_id: zone.id], query: [per_page: 10000]) do
    {:ok, %Tesla.Env{body: body, status: 200}} ->
      for dns <- body["result"] do
        %{
          id: dns["id"],
          name: dns["name"],
          type: dns["type"],
          ttl: dns["ttl"],
          content: dns["content"],
          proxied: dns["proxied"]
        }
      end

    {:ok, %Tesla.Env{body: body, status: 400}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {:ok, %Tesla.Env{body: body, status: 403}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {:ok, %Tesla.Env{body: body, status: 404}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {:ok, %Tesla.Env{body: body, status: 405}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {_, _} -> raise "Oops, something went wrong!"

  end

end

# ExCloudflare.create_dns_zone("subdomain6.mydomain.com", "CNAME", "google.com", 60, "mydomain.com")
def create_dns_zone(domain, type, content, ttl, zone_name) do
  Cloudflare.Client.init()

  zone = list_all_zone() 
              |> Enum.filter(& &1.name == zone_name) 
              |> Enum.at(0)

  create = 
    Cloudflare.DnsRecord.create(%{
      type: type, 
      name: domain, 
      content: content, 
      ttl: ttl}, params: [zone_id: zone.id])

  case create do

    {:ok, %Tesla.Env{body: body, status: 200}} ->
      dns = body["result"]
      IO.puts("""
      DNS successfully created!
      Id: #{dns["id"]}
      Name: #{dns["name"]}
      Type: #{dns["type"]}
      Ttl: #{dns["ttl"]}
      Content: #{dns["content"]}
      Proxied: #{dns["proxied"]}
      """)


    {:ok, %Tesla.Env{body: body, status: 400}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {:ok, %Tesla.Env{body: body, status: 403}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {:ok, %Tesla.Env{body: body, status: 404}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {:ok, %Tesla.Env{body: body, status: 405}} ->
      for error <- body["errors"] do
        error["message"]
      end

    {_, _} -> raise "Oops, something went wrong!"
  
  end
end

# ExCloudflare.update_dns_zone(%{name: "subdomain1.mydomain.com", type: "A", content: "127.0.0.1"}, "mydomain.com", %{content: "127.0.0.1", type: "A", name: "subdomain1", ttl: 60})
def update_dns_zone(id_body, zone_name, body) do
  Cloudflare.Client.init()

  zone = list_all_zone() 
          |> Enum.filter(& &1.name == zone_name) 
          |> Enum.at(0)

  dns = get_dnsrecord(zone_name)
          |> Enum.filter(& &1.name == id_body.name)
          |> Enum.filter(& &1.type == id_body.type)
          |> Enum.filter(& &1.content == id_body.content)
          |> Enum.at(0)

  if dns == nil do
    IO.puts("DNS não encontrado!")
  else
    update = Cloudflare.DnsRecord.update(dns.id, %{
      content: body.content, 
      type: body.type, 
      name: body.name, 
      comment: body.comment,
      proxied: body.proxied,
      ttl: body.ttl}, params: [zone_id: zone.id])

    case update do
      {:ok, %Tesla.Env{body: body, status: 200}} ->
      dns = body["result"]
      IO.puts("""
      DNS successfully updated!
      Id: #{dns["id"]}
      Name: #{dns["name"]}
      Type: #{dns["type"]}
      Ttl: #{dns["ttl"]}
      Content: #{dns["content"]}
      Proxied: #{dns["proxied"]}
      """)

      {:ok, %Tesla.Env{body: body, status: 400}} ->
        for error <- body["errors"] do
          error["message"]
        end

      {:ok, %Tesla.Env{body: body, status: 403}} ->
        for error <- body["errors"] do
          error["message"]
        end

      {:ok, %Tesla.Env{body: body, status: 404}} ->
        for error <- body["errors"] do
          error["message"]
        end

      {:ok, %Tesla.Env{body: body, status: 405}} ->
        for error <- body["errors"] do
          error["message"]
        end

      {_, _} -> raise "Oops, something went wrong!"

    end
  end
  
end

# ExCloudflare.delete_dns_zone(%{name: "subdomain5.mydomain.com", type: "A", content: "127.0.0.1"}, "mydomain.com")
def delete_dns_zone(id_body, zone_name) do
  Cloudflare.Client.init()

  zone = list_all_zone() 
          |> Enum.filter(& &1.name == zone_name) 
          |> Enum.at(0)

  dns = get_dnsrecord(zone_name)
          |> Enum.filter(& &1.name == id_body.name)
          |> Enum.filter(& &1.type == id_body.type)
          |> Enum.filter(& &1.content == id_body.content)
          |> Enum.at(0)

  if dns == nil do
    IO.puts("DNS Não encontrado!")
  else
    delete = Cloudflare.DnsRecord.delete(dns.id, params: [zone_id: zone.id])

    case delete do

      {:ok, %Tesla.Env{status: 200}} ->
        IO.puts("DNS ZONE Deleted Successfully!")


        {:ok, %Tesla.Env{body: body, status: 400}} ->
          for error <- body["errors"] do
            error["message"]
          end
        
        {:ok, %Tesla.Env{body: body, status: 403}} ->
          for error <- body["errors"] do
            error["message"]
          end
        
        {:ok, %Tesla.Env{body: body, status: 404}} ->
          for error <- body["errors"] do
            error["message"]
          end
        
        {:ok, %Tesla.Env{body: body, status: 405}} ->
          for error <- body["errors"] do
            error["message"]
          end
        
        {_, _} -> raise "Oops, something went wrong!"
    end
  end
end

end
