# frozen_string_literal: true

# Drops the tables installed by the geoblacklight_sidecar_images gem. Thumbnails
# now come from the http://schema.org/thumbnailUrl reference published in each
# document's dct_references field, so harvested sidecar images are unused.
class DropSidecarImageTables < ActiveRecord::Migration[8.1]
  def change
    drop_table :sidecar_image_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata
      t.integer :sort_key, null: false
      t.bigint :solr_document_sidecar_id, null: false
      t.boolean :most_recent
      t.timestamps null: false

      t.foreign_key :solr_document_sidecars
      t.index [ :solr_document_sidecar_id, :most_recent ],
        name: "index_sidecar_image_transitions_parent_most_recent", unique: true
      t.index [ :solr_document_sidecar_id, :sort_key ],
        name: "index_sidecar_image_transitions_parent_sort", unique: true
    end

    drop_table :solr_document_sidecars do |t|
      t.string :document_id
      t.string :document_type
      t.string :image
      t.bigint :version
      t.timestamps null: false

      t.index [ :document_type, :document_id ], name: "sidecars_solr_document"
    end
  end
end
