class EbookReaderController < ApplicationController
  require 'zip'
  require 'open-uri'
  require 'epub-reader/EpubReader.rb'
  require 'pathname'
  require 'tmpdir'
  require 'epub/parser'
  require 'uri'
  require 'elib/FileHandler.rb'
  require 'elib/Cors.rb'
  require 'aws-sdk-core'
  require 'aws-sdk'


  def index
    #File download
    puts "secret", ENV["s3_access_key"]
    # s3 = Aws::S3.new(
    #   :access_key_id =>   ENV["s3_access_key"],
    #   :secret_access_key => ENV["s3_secret_access_key"],
    #   :region => 'eu-central-1'
    # )
    #
    # obj =  s3.buckets['magazinos-ebook'].objects['test']
    # tree = bucket.objects.with_prefix('photos').as_tree
    #
    #
    # puts "w", obj.key
    # @url = obj.url_for(:read,
    #                  :response_content_type => "application/epub+zip")
    #
    # @content = obj.url_for(:get, :secure =>true ,:expires => 20.minutes.from_now).to_s
    #
    # puts "prov", @url

  #   s3 = Aws::S3::Client::new
  #     keys = []
  #   s3.list_objects(bucket: 'magazinos-ebook', prefix: 'test').contents.each { |e|
  #   keys << e.key
  # }
    #
    # presigner = Aws::S3::Presigner.new
    # presigner.presigned_url(:get_object, #method
    #                     bucket: 'magazinos-ebook', #name of the bucket
    #                     key: "test", #key name
    #                     expires_in: 7.days.to_i #time should be in seconds
    #                     ).to_s

  # @form = bucket.presigned_post(:key => "test")
  #
  #
  #   puts "reap", bucket
  #   puts "url" ,@form.url.to_s

    #web_contents =open('https://webservices.elib.se/v2/Fulfillment/?data=oLmSIPAVxrhlcN8mnYkjYg/fyIAuA1+xlRfyU4hDDRxwmFUdlM300leqzxKSXbPUIFRTzaf4aW/Nqw5TJTLFLICDVPxeFVi6YQTTaQNfPk28YiuPwnfbvqazFbdZAOFbXLGOF94HB2vbKiYbztVEsGzgkpU1Dgv/sy1RexVuZeBfrdTSr9aIYF6mqxcLOgLMr+GT1ikyyKdWmKI62+stFT5v2F0XQ5bWvi9DwBIZWGToRFf1Lpn16iEtyaxALkfl1fv4OkaezJFSd60RXkvd8H6YSKff3zVAKNdFLRmFoY+gJIy3q08THI7VnB2Yr8HB68EPg3LAVaRaTOeteJkFQbc3EX0tARcjPDIre2UpZFnpQDmcb6nPNQ==') {|f| f.read }

     #epubParser = EpubReader::GetEpubContentFrom.new('https://webservices.elib.se/v2/Fulfillment/?data=oLmSIPAVxrhlcN8mnYkjYg/fyIAuA1+xlRfyU4hDDRxwmFUdlM300leqzxKSXbPUIFRTzaf4aW/Nqw5TJTLFLICDVPxeFVi6YQTTaQNfPk28YiuPwnfbvqazFbdZAOFbXLGOF94HB2vbKiYbztVEsGzgkpU1Dgv/sy1RexVuZeBfrdTSr9aIYF6mqxcLOgLMr+GT1ikyyKdWmKI62+stFT5v2F0XQ5bWvi9DwBIZWGToRFf1Lpn16iEtyaxALkfl1fv4OkaezJFSd60RXkvd8H6YSKff3zVAKNdFLRmFoY+gJIy3q08THI7VnB2Yr8HB68EPg3LAVaRaTOeteJkFQbc3EX0tARcjPDIre2UpZFnpQDmcb6nPNQ==')
     #uri = URI("https://webservices.elib.se/v2/Fulfillment/?data=oLmSIPAVxrhlcN8mnYkjYg/fyIAuA1+xlRfyU4hDDRxwmFUdlM300leqzxKSXbPUIFRTzaf4aW/Nqw5TJTLFLICDVPxeFVi6YQTTaQNfPk28YiuPwnfbvqazFbdZAOFbXLGOF94HB2vbKiYbztVEsGzgkpU1Dgv/sy1RexVuZeBfrdTSr9aIYF6mqxcLOgLMr+GT1ikyyKdWmKI62+stFT5v2F0XQ5bWvi9DwBIZWGToRFf1Lpn16iEtyaxALkfl1fv4OkaezJFSd60RXkvd8H6YSKff3zVAKNdFLRmFoY+gJIy3q08THI7VnB2Yr8HB68EPg3LAVaRaTOeteJkFQbc3EX0tARcjPDIre2UpZFnpQDmcb6nPNQ==")
     #puts "uri", uri2
    #  file = File.open("/Users/Rasmus/elibmag/public/filtest/lol.epub", "r")
    #  uri = URI.parse("https://webservices.elib.se/v2/Fulfillment/?data=oLmSIPAVxrhlcN8mnYkjYg/fyIAuA1+xlRfyU4hDDRxwmFUdlM300leqzxKSXbPUIFRTzaf4aW/Nqw5TJTLFLICDVPxeFVi6YQTTaQNfPk28YiuPwnfbvqazFbdZAOFbXLGOF94HB2vbKiYbztVEsGzgkpU1Dgv/sy1RexVuZeBfrdTSr9aIYF6mqxcLOgLMr+GT1ikyyKdWmKI62+stFT5v2F0XQ5bWvi9DwBIZWGToRFf1Lpn16iEtyaxALkfl1fv4OkaezJFSd60RXkvd8H6YSKff3zVAKNdFLRmFoY+gJIy3q08THI7VnB2Yr8HB68EPg3LAVaRaTOeteJkFQbc3EX0tARcjPDIre2UpZFnpQDmcb6nPNQ==")
    #  puts "uri", uri
     #EPUB_URI = URI.parse(uri)

     download_dir = Pathname.new("/Users/Rasmus/elibmag/public/testpath")
     puts "download", download_dir
    #FileHandler::FileSaver.save_file_to_directory("https://webservices.elib.se/v2/Fulfillment/?data=oLmSIPAVxrhlcN8mnYkjYg/fyIAuA1+xlRfyU4hDDRxwmFUdlM300leqzxKSXbPUIFRTzaf4aW/Nqw5TJTLFLICDVPxeFVi6YQTTaQNfPk28YiuPwnfbvqazFbdZAOFbXLGOF94HB2vbKiYbztVEsGzgkpU1Dgv/sy1RexVuZeBfrdTSr9aIYF6mqxcLOgLMr+GT1ikyyKdWmKI62+stFT5v2F0XQ5bWvi9DwBIZWGToRFf1Lpn16iEtyaxALkfl1fv4OkaezJFSd60RXkvd8H6YSKff3zVAKNdFLRmFoY+gJIy3q08THI7VnB2Yr8HB68EPg3LAVaRaTOeteJkFQbc3EX0tARcjPDIre2UpZFnpQDmcb6nPNQ==", "zlatan")


    # FileHandler::UnzipHandler.unzip_file(file,"test87")
    # corsObject=Cors::HelloWorld.new
    # corsObject.call(self)

    # uploader = FileHandler::S3FolderUpload.new("testpath", 'magazinos-ebook', ENV["s3_access_key"], ENV["s3_secret_access_key"])
	  #  uploader.upload!
    #  puts "welwel"

     testbook = 'test'
    #  credentials = Aws::Credentials.new(ENV['s3_access_key'], ENV['s3_secret_access_key'])
     #
    #   s3 = Aws::S3::Client.new(region:ENV['aws_region'], credentials: credentials)
     #
    #   puts 'test', s3.list_buckets
    #   @resp = s3.get_object(bucket:'magazinos-ebook', key:'test/')
    #   aws_resource = Aws::S3::Resource::new(region:ENV['aws_region'], credentials: credentials)
     #
    #   @urle = aws_resource.bucket('magazinos-ebook').object('test/').presigned_url(:get, expires_in: 1*20.minutes)
     #Create client access to bucket
     #s3 = Aws::S3::Client.new(region:ENV['aws_region'], credentials: credentials)
     @ebookUrl = FileHandler::S3Cloud.get_ebook_url_from_cloud(testbook)

     puts "ebookcontroller", @ebookUrl

    #file.close
  #   def unzip_file (file, destination)
  #   Zip::ZipFile.open(file_path) { |zip_file|
  #       zip_file.each { |f|
  #           f_path=File.join("destination_path", f.name)
  #           FileUtils.mkdir_p(File.dirname(f_path))
  #           zip_file.extract(f, f_path) unless File.exist?(f_path)
  #       }
  #   }
  # end
  end
end
