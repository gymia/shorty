<?php
/**
 * Gymia Pre-Job Test
 * URL Shortner
 *
 * @author      MarQuis Knox <hire@marquisknox.com>
 * @copyright   2014 MarQuis Knox
 * @link        http://marquisknox.com
 * @license     GNU Affero General Public License
 * @license     http://www.gnu.org/licenses/agpl-3.0.html
 *
 * @since       Wednesday, September 24, 2014, 05:40 AM GMT+1 mknox
 * @edited      $Date$ $Author$
 * @version     $Id$
 *
 * @package     Gymia Pre-Job Test
 * @category    Models
*/

class Gymia_Shorty
{
    private $_db;
    private $_table;
    private $_reserved = array('reserved');

    public function __construct()
    {
        $this->_db      = Zend_Registry::get('dbAdapter');        
        $this->_table   = DB_TABLE_PREFIX.'url';
    }
    
    /**
     * Determine if a shortcode
     * is valid
     *
     * @param   string   $shortCode
     * @return  boolean
    */
    public function isValidShortCode( $shortCode = '' )
    {
        $shortCode = trim( $shortCode );
        if( !strlen( $shortCode ) ) {
            return false;
        }

        if( preg_match('/^[0-9a-z_]{4,}$/i', $shortCode ) ) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Determine if the supplied 
     * data is valid
     *
     * @param   array   $data
     * @return  array
    */
    public function isValid( $data = array() )
    {
        if( empty( $data ) ) {
            return false;
        }
    
        $error      = array();
        $required   = array( 'url', 'shortcode' );
        
        foreach( $required AS $key => $value ) {            
            switch( $value ) {
                case 'shortcode':
                    if( !$this->isValidShortCode( $data[$value] ) ) {
                        $error[] = array(
                            'code'      => 422,
                            'message'   => 'The shortcode ('.$data[$value].') fails to meet the following regexp: /^[0-9a-z_]{4,}$/i'
                        );                        
                    }
                    
                    if( $this->shortCodeHashExists( $data[$value] ) ) {
                        $error[] = array(
                            'code'      => 409,
                            'message'   => 'The desired shortcode is already in use'
                        );                        
                    }
                    
                    break;
                    
                case 'url':
                    if ( !strlen( $data[$value] ) ) {
                        $error[] = array(
                            'code'      => 400,
                            'message'   => 'url is not present'
                        );
                    }
                                        
                    break;
            }
        }
        
        return $error;
    }
    
    /**
     * Get an entry by 
     * short code
     * 
     * @param   string  $shortCode
     * @return  array
    */
    public function getByShortCode( $shortCode )
    {
        $result = array();
        
        $select = $this->_db->select()
        ->from( $this->_table )
        ->where( 'shortcode = ?', $shortCode )
        ->limit( 1 );  

        $result = $this->_db->fetchRow( $select );

        return $result;
    }
    
    /**
     * Get an entry by
     * short code hash
     *
     * @param   string  $shortCodeHash
     * @return  array
    */
    public function getByShortCodeHash( $shortCodeHash )
    {
        $result = array();
    
        $select = $this->_db->select()
        ->from( $this->_table )
        ->where( 'shortcode_hash = ?', $shortCodeHash )
        ->limit( 1 );
    
        $result = $this->_db->fetchRow( $select );
    
        return $result;
    }
    
    /**
     * Determine if a shortcode 
     * exists
     *
     * @param   string  $shortCode
     * @return  boolean
    */
    public function shortCodeExists( $shortCode )
    {
        $result = $this->getByShortCode( $shortCode );    
        if( !empty( $result ) ) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Determine if a shortcode
     * hash exists
     *
     * @param   string  $shortCode
     * @return  boolean
    */
    public function shortCodeHashExists( $shortCode )
    {
        $shortCode  = trim( $shortCode );        
        $hash       = sha1( $shortCode );
        $result     = $this->getByShortCodeHash( $hash );
        
        if( !empty( $result ) ) {
            return true;
        }
    
        return false;
    }

    /**
     * Generate a short code
     *
     * @param   int     $length
     * @param   boolean $shuffle
     * @param   boolean $shuffleInLoop
     * @return  string
     */
    public function generateShortCode( $length = MAX_SHORTCODE_LEN, $shuffle = true, $shuffleInLoop = true )
    {
        $characters     = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_';
        $randomString   = '';
    
        if( $shuffle ) {
            // shuffle
            str_shuffle( $characters );
        }
    
        for ( $i = 0; $i < $length; $i++ ) {
            if( $shuffleInLoop ) {
                // shuffle
                str_shuffle( $characters );
            }
    
            $randomString .= $characters[ rand( 0, strlen( $characters ) - 1 ) ];
        }
    
        return $randomString;
    }
    
    /**
     * Add an entry
     *
     * @param   array   $data
     * @return  mixed
    */
    public function insert( $data = array() )
    {
        $error = $this->isValid( $data );
        if( !empty( $error ) ) {
            return $error;            
        }
        
        if( empty( $data ) ) {
            return false;
        }
        
        // date created
        $data['date_created'] = time();
        
        // generate the shortcode if 
        // is not specified
        if( !strlen( @$data['shortcode'] ) ) {
            // generate the short code
            $data['shortcode'] = $this->generateShortCode(); 
            while( $this->shortCodeHashExists( $data['shortcode'] ) ) {
                $data['shortcode'] = $this->generateShortCode();
            }            
        }
        
        // trim
        $data = array_map( 'trim', $data );
        
        // shortcode hash
        $data['shortcode_hash'] = sha1( $data['shortcode'] );
        
        try {  
            $result = $this->_db->insert( $this->_table, $data );
            
            if( $result ) {
                $result = $this->_db->lastInsertId();
            }
        } catch ( Zend_Db_Exception $e ) {
            return $e->getMessage();
        }
        
        return $result;
    }
    
    /**
     * Get a random entry
     *
     * @return  array
    */
    public function getRandom()
    {
        $result = array();
    
        $select = $this->_db->select()
        ->from( $this->_table )
        ->order( 'RAND()' )
        ->limit( 1 );
    
        $result = $this->_db->fetchRow( $select );
    
        return $result;
    }
    
    /**
     * Update a record by ID
     * 
     * @param   int     $id
     * @param   array   $data
     * @return  boolean
    */
    public function updateById( $id, $data = array() )
    {
        return $this->_db->update( $this->_table, $data, 'id = '.(int)$id );        
    }
    
    /**
     * Increment the view count & 
     * update the access date
     *
     * @param   string  $shortCode
     * @return  boolean
    */
    public function updateViewsAndAccessDateByShortCode( $shortCode )
    {
        $data = array(
            'date_last_access'  => time(),
            'redirect_count'    => new Zend_Db_Expr( 'redirect_count + 1' )            
        );
        
        // where
        $where = array();
        $where['shortcode = ?'] = $shortCode;
        
        return $this->_db->update( $this->_table, $data, $where );
    }
}