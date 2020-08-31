# frozen_string_literal: true

GeoCombine::GeoBlacklightHarvester.document_transformer = -> (document) do
  %w[_version_ score timestamp bogus_field stanford_rights_metadata_s hashed_id_ssi layer_availability_score_f b1g_code_s b1g_dateAccessioned_s b1g_status_s b1g_date_range_drsim dct_accrualMethod_s b1g_genre_sm dct_alternativeTitle_sm b1g_keyword_sm b1g_centroid_ss solr_bboxtype__minX solr_bboxtype__minY solr_bboxtype__maxX solr_bboxtype__maxY].each do |field|
    document.delete(field)
  end

  document
end

GeoCombine::GeoBlacklightHarvester.configure do
  {
    commit_within: '300000',
    crawl_delay: 1,
    debug: true,
    STANFORD: {
      host: 'https://earthworks.stanford.edu/',
      params: {
        f: {
          access: ['public'],
          dct_provenance_s: ['Stanford']
        },
        q: '*'
      }
    },
    HARVARD: {
      host: 'https://earthworks.stanford.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['Harvard'],
          access: ['public']
        }
      }
    },
    COLUMBIA: {
      host: 'https://earthworks.stanford.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['Columbia'],
          access: ['public']
        }
      }
    },
    TUFTS: {
      host: 'https://earthworks.stanford.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['Tufts'],
          access: ['public']
        }
      }
    },
    NYU: {
      crawl_delay: 5,
      host: 'https://geo.nyu.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['NYU'],
          dc_rights_s: ['Public']
        }
      }
    },
    BARUCH: {
      crawl_delay: 5,
      host: 'https://geo.nyu.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['Baruch CUNY'],
          dc_rights_s: ['Public']
        }
      }
    },
    BIG10: {
      host: 'https://geo.btaa.org/',
      params: {
        q: '*',
        f: {
          dc_rights_s: ['Public']
        }
      }
    },
    CORNELL: {
      host: 'https://cugir.library.cornell.edu/',
      params: {
        q: '*',
      }
    },
    MIT: {
      crawl_delay: 5,
      host: 'https://geodata.mit.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['MIT'],
          dc_rights_s: ['Public']
        }
      }
    },
    BERKELEY: {
      crawl_delay: 5,
      host: 'https://geodata.lib.berkeley.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['Berkeley'],
          dc_rights_s: ['Public']
        }
      }
    },
    UVA: {
      crawl_delay: 5,
      host: 'https://gis.lib.virginia.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['UVa']
        }
      }
    },
    BOULDER: {
      crawl_delay: 5,
      host: 'https://geo.colorado.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['University of Colorado Boulder'],
          dc_rights_s: ['Public']
        }
      }
    },
    TEXAS: {
      crawl_delay: 5,
      host: 'https://geodata.lib.utexas.edu/',
      params: {
        q: '*',
        f: {
          dct_provenance_s: ['Texas'],
          dc_rights_s: ['Public']
        }
      }
    }
  }
end
