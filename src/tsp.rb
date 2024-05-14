INF = Float::INFINITY

def tsp(dist, mask, pos, n, dp, parent)
  return dist[pos][0] if mask == (1 << n) - 1

  return dp[pos][mask] if dp[pos][mask] != -1

  min = INF

  n.times do |city|
    if (mask & (1 << city)) == 0
      new_dist = dist[pos][city] + tsp(dist, mask | (1 << city), city, n, dp, parent)
      if new_dist < min
        min = new_dist
        parent[pos][mask] = city
      end
    end
  end

  dp[pos][mask] = min
  min
end

def print_path(parent, pos, mask, n)
  return if mask == (1 << n) - 1

  next_pos = parent[pos][mask]
  print "#{next_pos + 1} - "
  print_path(parent, next_pos, mask | (1 << next_pos), n)
end

def read_distances(file_path)
  dist = []
  File.readlines(file_path).each do |line|
    dist << line.split.map(&:to_i)
  end
  dist
end

puts "Masukkan nama file yang berisi matriks jarak:"
file_path = gets.chomp

begin
  dist = read_distances(file_path)
  n = dist.length

  dp = Array.new(n) { Array.new(1 << n, -1) }
  parent = Array.new(n) { Array.new(1 << n, -1) }

  puts "\n------------------------------------------------------------------------------------------------------------------------\n"
  puts "                                                   RUTE OPTIMAL                                                         "
  puts "------------------------------------------------------------------------------------------------------------------------\n\n"
  puts "   Titik mulai: 1                                                                                                    "
  res = tsp(dist, 1, 0, n, dp, parent)
  puts "   Jarak minimum: #{res} m                                                                                               "
  print "   Rute: 1 - "
  print_path(parent, 0, 1, n)
  puts "1    "
  puts "\n------------------------------------------------------------------------------------------------------------------------\n\n"
rescue Errno::ENOENT
  puts "FIle tidak ditemukan"
rescue => e
  puts "Error: #{e.message}"
end
