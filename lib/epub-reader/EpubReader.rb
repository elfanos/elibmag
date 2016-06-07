module EpubReader

  require 'pathname'
  require 'tmpdir'
  require 'epub/parser'

  # class EpubReader
  #     book = GEPUB::Book.new
  #     book.set_main_id('http:/example.jp/bookid_in_url', 'BookID', 'URL')
  #
  # end

  class GetEpubContentFrom
    EPUB_URI = URI.parse("https://webservices.elib.se/v2/Fulfillment/?data=oLmSIPAVxrhlcN8mnYkjYg/fyIAuA1+xlRfyU4hDDRxwmFUdlM300leqzxKSXbPUIFRTzaf4aW/Nqw5TJTLFLICDVPxeFVi6YQTTaQNfPk28YiuPwnfbvqazFbdZAOFbXLGOF94HB2vbKiYbztVEsGzgkpU1Dgv/sy1RexVuZeBfrdTSr9aIYF6mqxcLOgLMr+GT1ikyyKdWmKI62+stFT5v2F0XQ5bWvi9DwBIZWGToRFf1Lpn16iEtyaxALkfl1fv4OkaezJFSd60RXkvd8H6YSKff3zVAKNdFLRmFoY+gJIy3q08THI7VnB2Yr8HB68EPg3LAVaRaTOeteJkFQbc3EX0tARcjPDIre2UpZFnpQDmcb6nPNQ==")
    puts "EPUB_URI", EPUB_URI
    #EPUB_URI = URI.parse(uri)

    DOWNLOAD_DIR = Pathname.new("/Users/Rasmus/elibmag/public/testpath")
    $stderr.puts <<EOI
Started downloading EPUB contents...
  from: #{EPUB_URI}
  to:   #{DOWNLOAD_DIR}
EOI

    EPUB::OCF::PhysicalContainer.adapter = :UnpackedURI
      def initialize

      end

      def main
        make_mimetype

         container_xml = 'META-INF/container.xml'
         download container_xml
        #
         epub = EPUB::Parser.parse(EPUB_URI, container_adapter: :UnpackedURI)
         download epub.rootfile_path
        #
         epub.resources.each do |resource|
         download resource.entry_name
         end
         puts DOWNLOAD_DIR
      end

      def make_mimetype
        $stderr.puts "Making mimetype file..."
        DOWNLOAD_DIR.join('mimetype').write 'application/epub+zip'
      end

      def download(path)
        path = path.to_s
        src = EPUB_URI + path
        dest = DOWNLOAD_DIR + path
        $stderr.puts "Downloading #{path} ..."
        dest.dirname.mkpath
        dest.write src.read
      end
    end

  end
