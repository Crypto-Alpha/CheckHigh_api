# frozen_string_literal: true

require 'roda'
require 'json'

require_relative '../models/document'

module CheckHigh
  # Web controller for CheckHigh API
  class Api < Roda
    plugin :environments
    plugin :halt

    configure do
      Document.setup
    end

    route do |routing| # rubocop:disable Metrics/BlockLength
      response['Content-Type'] = 'application/json'

      routing.root do
        response.status = 200
        { message: 'CheckHighAPI up at /api/v1' }.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          routing.on 'documents' do
            # GET api/v1/documents/[id]
            routing.get String do |id|
              response.status = 200
              Document.find(id)
            rescue StandardError
              routing.halt 404, { message: 'Document not found' }.to_json
            end

            # GET api/v1/documents
            routing.get do
              response.status = 200
              output = { document_ids: Document.all }
              JSON.pretty_generate(output)
            end

            # POST api/v1/documents
            routing.post do
              new_doc = Document.new(request.params)

              if new_doc.save
                response.status = 201
                { message: 'Document saved', id: new_doc.id }.to_json
              else
                routing.halt 400, { message: 'Could not save document' }.to_json
              end
            end
          end
        end
      end
    end
  end
end