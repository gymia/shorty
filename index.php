<?php
/**
 * Gymia Pre-Job Test
 * URL Shortner
 *
 * @author      MarQuis Knox <hire@marquisknox.com>
 * @copyright   2014 MarQuis Knox
 * @link        http://marquisknox.com
 * @link        http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
 * @license     GNU Affero General Public License
 * @license     http://www.gnu.org/licenses/agpl-3.0.html
 *
 * @since       Wednesday, September 24, 2014, 03:36 AM GMT+1 mknox
 * @edited      $Date$ $Author$
 * @version     $Id$
 * 
 * @category    Site Index
 * @package     Gymia Pre-Job Test
*/

require_once( 'application/config/bootstrap.php' );
$Gymia_Shorty = new Gymia_Shorty;

// read the input
$input = file_get_contents('php://input');
$input = json_decode( $input, true );

// check requested endpoint
$endpoint = $_SERVER['REQUEST_URI'];
if( strlen( $endpoint ) ) {
    $endpoint = trim( $endpoint );
    $endpoint = trim( $endpoint, '/' );
}

if( !empty( $input ) ) {
    header('Content-type: application/json; charset=utf-8');    
    $json = array();
        
    switch( $endpoint ) {
        case 'shorten':
            // check for a user requested shortcode
            // & truncate if required
            if( isset( $input['shortcode'] ) ) {
                $input['shortcode'] = truncate( $input['shortcode'], MAX_SHORTCODE_LEN_CUSTOM );
            }
            
            // add to the DB
            $result = $Gymia_Shorty->insert( $input );
            
            if( !is_array( $result ) ) {
                $result = (int)$result;
                if( $result > 0 ) {
                    // entry was created
                    http_response_code( 201 );
                    $json['shortcode'] = $input['shortcode'];                    
                } else {
                    // the entry was not created
                    // http_response_code( 500 );
                    $json['error']          = 500;
                    $json['description']    = 'Entry not added';                  
                }
            } else {
                // return only the first error
                // http_response_code( $result[0]['code'] );
                $json['error']          = $result[0]['code'];
                $json['description']    = $result[0]['message'];
            }
            
            break;
            
        default:
            $json['error']          = 501;
            $json['description']    = 'UNSUPPORTED_METHOD';
    }
    
    exit( json_encode( $json ) );
} else {
    // check if the requested URI is a shortcode
    if( strlen( $endpoint ) ) { 
        // check if this is a stats request
        if( preg_match( '/.+\/stats/', $endpoint ) ) {
            // JSON header
            header('Content-type: application/json; charset=utf-8');
            
            // extract the shortcode
            $shortCode = rawurldecode( str_replace( array('/stats', '/stats/'), '', $endpoint ) );
            if( strlen( $shortCode ) ) {
                // fetch the record from the DB
                $data = $Gymia_Shorty->getByShortCode( $shortCode ); 
                if( !empty( $data ) ) {                    
                    $json               = array();
                    $json['startDate']  = date( DATE_ISO8601, $data['date_created'] );

                    if( $data['redirect_count'] > 0 ) {
                        $json['lastSeenDate'] = date( DATE_ISO8601, $data['date_last_access'] );
                    }
                    
                    $json['redirectCount'] = $data['redirect_count'];

                    exit( json_encode( $json ) );
                } else {
                    $json                   = array();
                    $json['error']          = 404;
                    $json['description']    = 'The shortcode cannot be found in the system';

                    exit( json_encode( $json ) );
                }            
            } else {
                // @todo
                // display an error message...
            }
        } else {
            // fetch the record from the DB
            $data = $Gymia_Shorty->getByShortCode( $endpoint );           
            if( !empty( $data ) ) {
                // update the metadata
                $Gymia_Shorty->updateViewsAndAccessDateByShortCode( $data['shortcode'] );
            
                // redirect
                header( 'Location: '.$data['url'] );
                exit;
            } else {
                $json                   = array();
                $json['error']          = 404;
                $json['description']    = 'The shortcode cannot be found in the system';
    
                exit( json_encode( $json ) );
            }            
        }
    }
    
    // notify the user that the absence of a UI is intentional
    $notice = 'This application does not require a user interface. ';
    $notice .= 'Specs:  <a href="https://github.com/gymia/shorty" target="_blank">https://github.com/gymia/shorty</a>';
    
    echo $notice;    
}