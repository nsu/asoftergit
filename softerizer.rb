# and cap.length < indices[0]
require 'flickraw'
require 'RMagick'
require 'digest/md5'
require 'github_api'

include Magick



def gen_caption(capText)
  if capText.length >= 33 then
    capNum = Random.rand((capText.length/33.0).ceil..((capText.length/33.0).ceil+1))
    indices = [Random.rand(0..33)]
    while indices.length < capNum do
      indices << Random.rand(indices[indices.length-1]..(indices[indices.length-1]+33))
      indices = indices.uniq
      indices = indices.sort
    end
    indices << capText.length
    finals = Array[]
    capText = capText.split.reverse
    while capText.length != 0 do
      cap = capText.pop()
      while capText[capText.length-1] != nil do
        nextLen = cap.length + capText[capText.length-1].length
        if nextLen + finals.join(" ").length <= indices[0] then
          cap = cap + " " + capText.pop()
        else
          break
        end
      end
      finals << cap
      indices.delete_at(0)
    end
    capText = finals
  else
    capText = [capText]
  end
  retCaptions = Array[]
  capText.each do |cap|
    caption = Image.new(cap.length*11+13, 20) {self.background_color = "white"}
    title = Draw.new
    title.annotate(caption, 0,0,7,2, cap) {
          self.font_family = 'Courier 10 Pitch'
          self.fill = 'black'
          self.stroke = 'transparent'
          self.pointsize = 18
          self.font_weight = BoldWeight
          self.gravity = NorthWestGravity
    }
    filename = Digest::MD5.hexdigest(cap) + ".png"
    caption.write("tmp/"+filename)
    caption.write(filename)
    retCaptions << filename
  end
  return retCaptions
end

def get_commit(user, repo)
  github = Github.new
  commits = github.repos.commits.all  user, repo#, per_page: 2, page: Random.rand(0..20)
  message = commits[Random.rand(0..commits.length-1)].commit.message
  return message
end

def get_flickr(user, pagenum)

  while true do
    begin
      # id = flickr.people.findByUsername(:username => user).id
      id = user
      photoList = flickr.photos.search(:user_id => id, :per_page => 50, :page => pagenum)
      while photoList.length == 0 do
        pagenum = pagenum -1
        photoList = flickr.photos.search(:user_id => id, :per_page => 50, :page => pagenum)
      end
      p = photoList[Random.rand(0..photoList.length-1)]


      info = flickr.photos.getInfo(:photo_id => p.id)
      photo_url = FlickRaw.url_b(info)

      tags = info.tags.map {|t| t.raw}

      name = photo_url.split('/')[-1]

      puts URI.parse(photo_url)

      open("img/" + name, "wb") { |file|
       file.write(Net::HTTP.get_response(URI.parse(photo_url)).body)
      }

      img = ImageList.new("img/" + name)

      # hipsterize it
      rotation = Random.rand(-5..5)
      newimg = img.rotate(rotation)
      randscale = Random.rand(50..200)/100.0
      # puts randscale, rotation
      newimg = img.scale(randscale)
      # newimg = newimg.rotate(rotation)

      yCrop = Random.rand(0..newimg.rows-400)
      xCrop = Random.rand(0..newimg.columns-400)

      newimg = newimg.crop(xCrop, yCrop, 400, 400)
      newimg = newimg.gaussian_blur(radius=5.0)
      newimg = newimg.quantize(256, GRAYColorspace)
      newimg.border!(13, 10, "#222431")
      newimg.write(name)
      return name, user
    rescue FlickRaw::OAuthClient::FailedResponse, ArgumentError
      redo
    end
  end
end

def gen_X(src, dest)
  destX = dest[0].columns
  srcX = src[0].columns
  maxX = destX-srcX
  if maxX-18 < 17
    xOffset = 18
  else
    xOffset = Random.rand(18..maxX-18)
  end
  return xOffset
end

def gen_Y(src, dest, minY, maxY)
  minY = minY
  destY = dest[0].rows
  srcY = src[0].rows
  if maxY-18 < 17
    yOffset = 18
  else
    yOffset = Random.rand(minY..maxY)
  end
  return yOffset
end

def add_caption(captionFiles, imageFile)
    dest = ImageList.new(imageFile)

    filename = Digest::MD5.hexdigest(captionFiles[0]+imageFile) + ".png"
    yOffset = 18
    if captionFiles.length > 0 then
      maxY = dest[0].rows/captionFiles.length
    else
      maxY = dest[0].rows-38
    end

    captionFiles.each_with_index do |captionFile, index|
      src = ImageList.new(captionFile)
      xOffset = gen_X(src, dest)
      if yOffset+20 > maxY then
        break
      end
      yOffset = gen_Y(src, dest, yOffset+20, maxY)
      maxY = yOffset+Random.rand(31..33)

      newimg = dest[0].composite(src, xOffset, yOffset, AtopCompositeOp)
      newimg.write(filename)
      dest = ImageList.new(filename)
    end

    return filename
end

def composite_panels(panel1, panel2, panel3)
  panels = ImageList.new(panel1, panel2, panel3)
  comp = Image.new(1340, 436){self.background_color = "white"}

  comp = comp.composite(panels[0], 10, 10, AtopCompositeOp)
  comp = comp.composite!(panels[1], 450, 10, AtopCompositeOp)
  comp = comp.composite!(panels[2], 890, 10, AtopCompositeOp)
  return comp
end


def gen_comic(filename)
  # flickrUsers = ["68841495@N02", "50979393@N00", "11821713@N00", "54225656@N05", "53986933@N00", "27385478@N02"]
  flickrUsers = ["68841495@N02", "27385478@N02", "50979393@N00", "21439390@N00", "90203881@N02"]

  githubRepos = [
    ["zedshaw", "mongrel2"], ["lockitron", "selfstarter"], ["ianawilson", "trainingyrhuman"], ["jquery", "jquery"],
    ["stedolan", "jq"], ["jquery", "jquery-ui"], ["yuzawa-san", "instinctiveScroll"], ["twitter", "bootstrap"],
    ["benoitc", "gunicorn"], ["iccelou91", "cs3013-a12"], ["joyent", "node"], ["rails","rails"], ["bartaz", "impress.js"],
    ["mxcl", "homebrew"], ["mbostock", "d3"], ["facebook", "three20"], ["cloudhead", "less.js"],
    ["meteor", "meteor"], ["django", "django"], ["antirez", "redis"], ["memcached", "memcached"], ["git-mirror", "nginx"],
    ["JRoTheGeek", "CS-3516-Project-2"], ["saulshanabrook", "django-canadanewyork"]
  ]

  FlickRaw.api_key="6564e82abc126382a9f02049d13c25ae"
  FlickRaw.shared_secret="24f2aec321ca9138"

  repo = githubRepos[Random.rand(0..githubRepos.length-1)]
  message = get_commit(repo[0], repo[1]).split
  while message.length <=2
    message = get_commit(repo[0], repo[1]).split
  end

  if message.length > 3 then
    first = Random.rand(0..message.length-3)
    second = Random.rand(first+1..message.length-2)
    third = message.length-1
    firstCap = message[0..first].join(" ")
    secondCap = message[first+1..second].join(" ")
    thirdCap = message[second+1..third].join(" ")
  elsif message.length == 3
    first = 0
    second = 1
    third = 2
    firstCap = message[0..first].join(" ")
    secondCap = message[first+1..second].join(" ")
    thirdCap = message[second+1..third].join(" ")
  else
    first = 0
    second = 0
    third = 2
    firstCap = message[0..first].join(" ")
    secondCap = message[first+1..second].join(" ")
    thirdCap = message[second+1..third].join(" ")
  end


  puts repo
  puts firstCap
  puts secondCap
  puts thirdCap
  puts

  cap1 = gen_caption(firstCap)
  cap2 = gen_caption(secondCap)
  cap3 = gen_caption(thirdCap)

  user = flickrUsers[Random.rand(0..flickrUsers.length-1)]

  pagenum = Random.rand(0..5)

  im1, phtg1 = get_flickr(user, pagenum)

  im2, phtg2 = get_flickr(user, pagenum)

  im3, phtg3 = get_flickr(user, pagenum)

  photographer = user

  panel1 = add_caption(cap1, im1)
  panel2 = add_caption(cap2, im2)
  panel3 = add_caption(cap3, im3)
  comp = composite_panels(panel1, panel2, panel3)
  comp = comp.scale(900, 293)
  comp.write(filename) { self.quality = 800 }
end

(81..90).to_a.each do |num|
  puts num
  gen_comic("comics/" + num.to_s + ".png")
end


__END__

  #add text

  content = ["Life is what happens", "while you're waiting", "for revenge"]

  # This is a shiny way to add texture to the background, but that seems to be unnecessary
  # caption = ImageList.new("ricepaper2.png")
  # title = Draw.new
  # title.annotate(caption, 0,0,7,4, content[0]) {
  #     self.font_family = 'Courier 10 Pitch'
  #     self.fill = 'black'
  #     self.stroke = 'transparent'
  #     self.pointsize = 11
  #     self.font_weight = BoldWeight
  #     self.gravity = NorthWestGravity
  # }
  #
  # caption.write("caption.png")
  # caption = Magick::ImageList.new("ricepaper.png", "caption.png")
  # caption = caption.flatten_images()
  # caption = caption.crop(0, 0, content[0].length*7+12, 18)
  # caption.write("caption.png")
  # break


  # Save it as a new comic panel!

  # newimg.push caption

  newimg.write("%s.png" % index)
  if index == 20
    break
  end
end
