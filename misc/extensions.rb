$extensions = {}
$shareable = []
$mutually_exclusive = Hash.new { |hash, key| hash[key] = [] }
$team = {}

def extension(id, weight, shareable: false)
  raise 'Multiply defined extension' if $extensions.has_key? id

  $extensions[id] = weight
  $shareable << id if shareable
end

def mutually_exclusive(*ids)
  ids.each do |id|
    raise "Unknown extension #{id}" unless $extensions.has_key? id
  end

  (0...ids.size).each do |i|
    id = ids[i]
    other = ids[0...i] + ids[i+1..-1]

    raise "Inconsistent mutually exclusive for #{id}" if $mutually_exclusive.has_key? id
    
    $mutually_exclusive[id] = other
  end
end

class TeamMemberContext
  def initialize(member_id)
    raise "Team member #{member_id} already exists" if $team.has_key? member_id
    
    @member_id = member_id
    $team[member_id] = []
  end
  
  def extension(extension_id)
    abort "Unknown extension #{extension_id} for team member #{@member_id}; use custom_extension for non-standard extensions" unless $extensions.has_key? extension_id

    abort "Team member #{@member_id} registered extension #{extension_id} twice" if $team[@member_id].member? extension_id
    
    if (mutually_exclusive_with = find_mutually_exclusive extension_id)
      abort "Team member #{@member_id} has mutually exclusive extensions: #{extension_id} and #{mutually_exclusive_with}"
    end

    if !$shareable.member? extension_id and (other_member = $team.keys.find do |member_id|
          $team[member_id].member? extension_id
        end)
      abort "Team members #{@member_id} and #{other_member} both made extension #{extension_id}"
    end

    $team[@member_id] << extension_id
  end

  def custom_extension(extension_id)
    abort "Custom extension's name clashes with regular extension: #{extension_id}" if $extensions.has_key? extension_id

    $team[@member_id] << extension_id
  end

  def find_mutually_exclusive(extension_id)
    $mutually_exclusive[extension_id].find do |exclusive_with|
      $team[@member_id].member? exclusive_with
    end
  end
end

def team_member(member_id, &block)
  TeamMemberContext.new(member_id).instance_eval(&block)
end

# def remove_mutually_exclusives(extensions)
#   result = []

#   extensions.each do |extension|
#     mutually_exclusive_with = $mutually_exclusive[extension]

#     unless mutually_exclusive_with.any? { |x| result.member? x }
#       result << extension
#     end
#   end

#   extension
# end

def extension_difficulties(member_id)
  extensions = $team[member_id]
  
  extension_difficulties = extensions.map do |extension|
    if $extensions.has_key? extension
    then $extensions[extension]
    else :custom
    end
  end

  n0, n1, n2, n3, n4, n5 = [:custom, 1, 2, 3, 4, 5].map do |difficulty|
    extension_difficulties.count(difficulty)
  end

  { 'custom' => n0,
    'green' => n1,
    'green-orange' => n2,
    'orange' => n3,
    'orange-red' => n4 + n5 }
end

def print_statistics
  $team.keys.each do |member_id|
    implemented = extension_difficulties member_id

    puts (caption = "Team member #{member_id}")
    puts( "-" * caption.size )
    implemented.each do |difficulty, count|
      puts "#{difficulty}: #{count}"
    end

    n1 = implemented['green']
    n2 = implemented['green-orange']
    n3 = implemented['orange']
    n4 = implemented['orange-red']

    if n4 >= 2
      n3 += n4 - 2
    else
      puts "*** Insufficient orange-red extensions: #{n4} out of 2"
    end

    if n3 >= 3
      n2 += n3 - 3
    else
      puts "*** Insufficient orange extensions: #{n3} out of 3"
    end

    if n2 >= 4
      n2 += n2 - 4
    else
      puts "*** Insufficient green-orange extensions: #{n2} out of 4"
    end

    unless n1 >= 5
      puts "*** Insufficient green extensions: #{n1} out of 5"
    end

    puts
  end
end

extension 'basic sample', 1, shareable: true
extension 'basic scripting', 1, shareable: true
extension 'ray tracer v1', 1, shareable: true
extension 'ray tracer v2', 2
extension 'ray tracer v3', 2
extension 'ray tracer v4', 2
extension 'ray tracer v5', 3
extension 'ray tracer v6', 4
extension 'random sampler', 2
extension 'stratified sampler', 2
extension 'jittered sampler', 2
extension 'half jittered sampler', 2
extension 'nrooks sampler', 3
extension 'multijittered sampler', 4
extension 'depth of field camera', 3
extension 'fisheye camera', 4
extension 'orthographic camera', 4
extension 'directional light', 2
extension 'spot light', 3
extension 'area light', 2
extension 'voronoi 2d', 5
extension 'voronoi3d', 5
extension 'material dalmatian 2d', 5
extension 'material vertical lines', 2
extension 'material grid2d', 2
extension 'material checkered 2d', 2
extension 'material dalmatian 3d', 5
extension 'material grid3d', 2
extension 'material checkered 3d', 2
extension 'material worley 2d', 3
extension 'material worley 3d', 3
extension 'material perlin 2d', 5
extension 'material perlin 3d', 5
extension 'material marble 2d', 3
extension 'material marble 3d', 3
extension 'material transformer 2d', 3
extension 'material transformer 3d', 3
extension 'material scale 2d', 3
extension 'material scale 3d', 3
extension 'material translate 2d', 3
extension 'material translate 3d', 3
extension 'material rotate 2d', 3
extension 'material rotate 3d', 3
extension 'plane xz', 1
extension 'plane yz', 1
extension 'plane xz optimized', 1
extension 'plane yz optimized', 1
extension 'cone along x', 3
extension 'cone along y', 3
extension 'cone along z', 3
extension 'cone along x optimized', 2
extension 'cone along y optimized', 2
extension 'cone along z optimized', 2
extension 'square xy', 1
extension 'square xz', 1
extension 'square yz', 1
extension 'square xy optimized', 1
extension 'square xz optimized', 1
extension 'square yz optimized', 1
extension 'cube', 2
extension 'cylinder along x', 2
extension 'cylinder along y', 2
extension 'cylinder along z', 2
extension 'cylinder along x optimized', 1
extension 'cylinder along y optimized', 1
extension 'cylinder along z optimized', 1
extension 'triangle', 2
extension 'triangle optimized', 1
extension 'bounding box', 2
extension 'mesh', 5
extension 'mesh reader', 4
extension 'bbh algorithm', 5
extension 'cropper', 3
extension 'cropper optimized', 2
extension 'bumpifier', 5
extension 'intersection', 5
extension 'intersection optimized', 2
extension 'difference', 5
extension 'difference optimized', 2
extension 'primitive scaling', 1
extension 'primitive rotation x', 1
extension 'primitive rotation y', 1
extension 'primitive rotation z', 1
extension 'group', 2
extension 'edge', 5
extension 'cartoon', 3
extension 'parallel scheduler', 4
extension 'motion blur', 4
extension 'bmp', 2
extension 'ppm', 3
extension 'easing library', 2
extension 'bounce', 3
extension 'elastic', 3
extension 'quadratic', 4
extension 'cubic', 4
extension 'quintic',4 
extension 'point animation', 2
extension 'angle animation', 2
extension 'quaternions', 2
extension 'circular animation', 2
extension 'lissajous', 4
extension 'cyclic', 3
extension 'slicer', 3

mutually_exclusive 'bounce', 'elastic'
mutually_exclusive 'plane xz', 'plane yz'
mutually_exclusive 'plane xz optimized', 'plane yz optimized'
mutually_exclusive 'cone along x', 'cone along y', 'cone along z'
mutually_exclusive 'cone along x optimized', 'cone along y optimized', 'cone along z optimized'
mutually_exclusive 'square xy', 'square xz', 'square yz'
mutually_exclusive 'square xy optimized', 'square xz optimized', 'square yz optimized'
mutually_exclusive 'cylinder along x', 'cylinder along y', 'cylinder along z'
mutually_exclusive 'cylinder along x optimized', 'cylinder along y optimized', 'cylinder along z optimized'
mutually_exclusive 'primitive rotation x', 'primitive rotation y', 'primitive rotation z'
mutually_exclusive 'material scale 2d', 'material translate 2d', 'material rotate 2d'
mutually_exclusive 'material scale 3d', 'material translate 3d', 'material rotate 3d'
mutually_exclusive 'quadratic', 'cubic', 'quintic'
mutually_exclusive 'point animation', 'angle animation'

load 'team-data.rb'

print_statistics
